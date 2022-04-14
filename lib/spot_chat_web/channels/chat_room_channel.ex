defmodule SpotChatWeb.ChatRoomChannel do
  use SpotChatWeb, :channel

  import Ecto.Query

  alias SpotChat.{Repo, Room, Message}
  alias SpotChatWeb.Presence

  @impl true
  def join("chat_room:" <> room_id, _payload, socket) do
    current_user = socket.assigns.current_user
    room = Repo.get!(Room, room_id)

    query =
      from(m in Message, where: m.room_id == ^room.id, order_by: [desc: m.inserted_at, desc: m.id])

    page =
      Repo.paginate(
        query,
        cursor_fields: [{:inserted_at, :desc}, {:id, :desc}],
        limit: 25
      )

    response = %{
      room:
        Phoenix.View.render_one(
          %{room: room, user_id: current_user.userId},
          SpotChatWeb.RoomView,
          "room.json"
        ),
      messages:
        Phoenix.View.render(
          SpotChatWeb.MessageView,
          "block.json",
          %{room: room, messages: page.entries, user_id: current_user.userId}
        ),
      pagination: SpotChatWeb.PaginationHelpers.pagination(page)
    }

    send(self(), :after_join)
    {:ok, response, assign(socket, :room, room)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    current_user = socket.assigns.current_user
    room = socket.assigns.room

    # Move this to helper
    chat_profile_id =
      :crypto.hash(:sha256, room.id <> current_user.userId)
      |> Base.encode16()

    {:ok, _} = Presence.track(socket, chat_profile_id, %{joined_at: DateTime.utc_now()})
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat_room:lobby).
  @impl true
  def handle_in("new_message", payload, socket) do
    changeset =
      socket.assigns.room
      |> Ecto.build_assoc(:message, user_id: socket.assigns.current_user.userId)
      |> Message.changeset(payload)

    case Repo.insert(changeset) do
      {:ok, message} ->
        broadcast_message(socket, message)
        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply,
         {:error,
          Phoenix.View.render(SpotChatWeb.ChangesetView, "error.json", changeset: changeset)},
         socket}
    end
  end

  @impl true
  def terminate(_reason, socket) do
    {:ok, socket}
  end

  defp broadcast_message(socket, message) do
    room = Repo.get!(Room, message.room_id)
    # get user info, and choose what to include
    rendered_message_from =
      Phoenix.View.render_one(
        %{
          room: room,
          message: message,
          owned: false
        },
        SpotChatWeb.MessageView,
        "message.json"
      )

    broadcast_from!(socket, "message_created", rendered_message_from)

    rendered_message_push =
      Phoenix.View.render_one(
        %{
          room: room,
          message: message,
          owned: true
        },
        SpotChatWeb.MessageView,
        "message.json"
      )

    push(socket, "message_created", rendered_message_push)
  end

  # defp verify_user(%{"password" => password} = params) do
  #   params
  #   |> Argon2.check_pass(password)
  # end
end
