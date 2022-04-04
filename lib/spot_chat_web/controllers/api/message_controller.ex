defmodule SpotChatWeb.MessageController do
  use SpotChatWeb, :controller

  alias SpotChat.{Repo, Message, Room}

  import Ecto.Query

  def index(conn, params) do
    current_user = conn.assigns.current_user
    before = params["before"] || nil
    room = Repo.get!(Room, params["room_id"])

    query =
      from(m in Message, where: m.room_id == ^room.id, order_by: [desc: m.inserted_at, desc: m.id])

    page =
      Repo.paginate(
        query,
        before: before,
        cursor_fields: [:inserted_at, :id],
        limit: 25
      )

    render(conn, "index.json", %{
      room: room,
      messages: page.entries,
      user_id: current_user.userId,
      pagination: SpotChatWeb.PaginationHelpers.pagination(page)
    })
  end
end
