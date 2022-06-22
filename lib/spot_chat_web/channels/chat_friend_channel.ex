defmodule SpotChatWeb.ChatFriendChannel do
  use SpotChatWeb, :channel

  import Ecto.Query

  alias SpotChat.{Repo, FriendRoom, FriendMessage}
  alias SpotChatWeb.Presence

  @impl true
  def join("chat_friend:" <> friend_id, _payload, socket) do
    # the friend_id is the relationshipm we need to actually get the friend
    url = "http://localhost:3000/chat/friend/" <> friend_id

    headers = [
      Authorization: "Bearer #{socket.assigns.token}",
      Accept: "Application/json; Charset=utf-8"
    ]

    friend =
      case HTTPoison.get(url, headers) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          response = Poison.decode!(body)
          response["friend"]

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          {:error, %{reason: "friend does not exist"}}

        {:error, %HTTPoison.Error{reason: _reason}} ->
          {:error, %{reason: "friend does not exist"}}
      end

    current_user = socket.assigns.current_user

    room_query =
      from(r in FriendRoom,
        where:
          (r.user_id == ^current_user.userId and r.friend_id == ^friend["userId"]) or
            (r.user_id == ^friend["userId"] and r.friend_id == ^current_user.userId)
      )

    friend_room = Repo.one(room_query)

    # these users have not chatted yet
    if is_nil(friend_room) do
      changeset =
        FriendRoom.changeset(
          %FriendRoom{},
          %{
            user_id: current_user.userId,
            friend_id: friend["userId"]
          }
        )

      case Repo.insert(changeset) do
        {:ok, room} ->
          ^friend_room = room

        {:error, _changeset} ->
          {:error, %{reason: "friend does not exist"}}
      end
    end

    query =
      from(m in FriendMessage,
        where: m.friend_room_id == ^friend_room.id,
        order_by: [desc: m.inserted_at, desc: m.id]
      )

    page =
      Repo.paginate(
        query,
        cursor_fields: [{:inserted_at, :desc}, {:id, :desc}],
        limit: 25
      )

    response = %{
      messages:
        Phoenix.View.render(
          SpotChatWeb.FriendMessageView,
          "block.json",
          %{messages: page.entries, user_id: current_user.userId}
        ),
      pagination: SpotChatWeb.PaginationHelpers.pagination(page)
    }

    send(self(), :after_join)
    assign(socket, :friend_user, friend)
    {:ok, response, assign(socket, :friend_room, friend_room)}
  end

  @impl true
  def handle_info(:after_join, socket) do
    current_user = socket.assigns.current_user
    friend_room = socket.assigns.friend_room

    if current_user.userId == friend_room.user_id do
    {:ok, _} = Presence.track(socket, "user_1", %{joined_at: DateTime.utc_now()})
    else
    {:ok, _} = Presence.track(socket, "user_2", %{joined_at: DateTime.utc_now()})
    end

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat_room:lobby).
  @impl true
  def handle_in("new_message", payload, socket) do
    friend_room = socket.assigns.friend_room

    # create the new message and broadcast it
    changeset =
      friend_room
      |> Ecto.build_assoc(:friend_message, user_id: socket.assigns.current_user.userId)
      |> FriendMessage.changeset(payload)

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
    # get user info, and choose what to include
    rendered_message_from =
      Phoenix.View.render(
        SpotChatWeb.FriendMessageView,
        "message.json",
        %{
          message: message,
          owned: false
        }
      )

    broadcast_from!(socket, "message_created", rendered_message_from)

    rendered_message_push =
      Phoenix.View.render(
        SpotChatWeb.FriendMessageView,
        "message.json",
        %{
          message: message,
          owned: true
        }
      )

    push(socket, "message_created", rendered_message_push)
  end

  # defp verify_user(%{"password" => password} = params) do
  #   params
  #   |> Argon2.check_pass(password)
  # end
end
