defmodule SpotChatWeb.ChatRoomChannel do
  use SpotChatWeb, :channel

  import Ecto.Query

  alias SpotChat.{Repo, Room, Message}

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
        Enum.map(page.entries, fn message ->
          Phoenix.View.render_one(
            %{
              message: message,
              owned: message.user_id == current_user.userId,
              profile:
                SpotChatWeb.ProfileHelpers.getProfile(%{
                  room: room,
                  message: message,
                  user_id: current_user.userId
                })
            },
            SpotChatWeb.MessageView,
            "message.json"
          )
        end),
      pagination: SpotChatWeb.PaginationHelpers.pagination(page)
    }

    {:ok, response, assign(socket, :room, room)}
  end

  # @impl true
  # def handle_info(:after_join, socket) do
  #   message = %{
  #     "content" => "User joined chat",
  #     "timestamp" => DateTime.utc_now(),
  #     "type" => "INFO",
  #     "profilePicture" => -1,
  #     "profilePictureSrc" => "op.png",
  #     "owned" => true
  #   }

  #   push(socket, "new_message", message)
  #   {:noreply, socket}
  # end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # @impl true
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

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
          message: message,
          owned: false,
          profile:
            SpotChatWeb.ProfileHelpers.getProfile(%{
              room: room,
              message: message,
              user_id: message.user_id
            })
        },
        SpotChatWeb.MessageView,
        "message.json"
      )

    broadcast_from!(socket, "message_created", rendered_message_from)

    rendered_message_push =
      Phoenix.View.render_one(
        %{
          message: message,
          owned: true,
          profile:
            SpotChatWeb.ProfileHelpers.getProfile(%{
              room: room,
              message: message,
              user_id: message.user_id
            })
        },
        SpotChatWeb.MessageView,
        "message.json"
      )

    push(socket, "message_created", rendered_message_push)
  end
end
