defmodule SpotChatWeb.FriendMessageController do
  use SpotChatWeb, :controller

  alias SpotChat.{Repo, FriendMessage, FriendRoom}

  import Ecto.Query

  def index(conn, params) do
    current_user = conn.assigns.current_user
    before = params["before"] || nil
    friend_room = Repo.get!(FriendRoom, params["room_id"])

    query =
      from(m in FriendMessage, where: m.friend_room_id == ^friend_room.id, order_by: [desc: m.inserted_at, desc: m.id])

    page =
      Repo.paginate(
        query,
        before: before,
        cursor_fields: [:inserted_at, :id],
        limit: 25
      )

    render(conn, "index.json", %{
      friend_room: friend_room,
      messages: page.entries,
      user_id: current_user.userId,
      pagination: SpotChatWeb.PaginationHelpers.pagination(page)
    })
  end
end
