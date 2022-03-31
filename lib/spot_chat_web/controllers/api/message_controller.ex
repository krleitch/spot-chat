defmodule SpotChatWeb.MessageController do
  use SpotChatWeb, :controller

  import Ecto.Query

  def index(conn, params) do
    current_user = conn.assigns.current_user
    before = params["before"] || 0
    room = SpotChat.Repo.get!(SpotChat.Room, params["room_id"])

    page =
      SpotChat.Message
      |> where([m], m.room_id == ^room.id)
      |> where([m], m.id < ^before)
      |> order_by(desc: :inserted_at, desc: :id)
      |> preload(:user)
      |> SpotChat.Repo.paginate()

    render(conn, "index.json", %{
      messages: page.entries,
      user_id: current_user.userId,
      pagination: SpotChatWeb.PaginationHelpers.pagination(page)
    })
  end
end
