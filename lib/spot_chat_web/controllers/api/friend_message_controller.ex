defmodule SpotChatWeb.FriendMessageController do
  use SpotChatWeb, :controller

  alias SpotChat.{Repo, FriendMessage, FriendRoom}

  import Ecto.Query

  def index(conn, params) do
    current_user = conn.assigns.current_user
    before = params["before"] || nil
    friend_id = params["id"]
    token = get_token(conn)

    # the friend_id is the relationshipm we need to actually get the friend
    url = "http://localhost:3000/chat/friend/" <> friend_id

    headers = [
      Authorization: "Bearer #{token}",
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

    room_query =
      from(r in FriendRoom,
        where:
          (r.user_id == ^current_user.userId and r.friend_id == ^friend["userId"]) or
            (r.user_id == ^friend["userId"] and r.friend_id == ^current_user.userId)
      )

    friend_room = Repo.one(room_query)

    query =
      from(m in FriendMessage,
        where: m.friend_room_id == ^friend_room.id,
        order_by: [desc: m.inserted_at, desc: m.id]
      )

    page =
      Repo.paginate(
        query,
        before: before,
        cursor_fields: [:inserted_at, :id],
        limit: 25
      )

    render(conn, "index.json", %{
      messages: page.entries,
      user_id: current_user.userId,
      pagination: SpotChatWeb.PaginationHelpers.pagination(page)
    })
  end

  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["bearer " <> token] -> token
      _ -> nil
    end
  end
end
