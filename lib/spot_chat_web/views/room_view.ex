defmodule SpotChatWeb.RoomView do
  use SpotChatWeb, :view

  def render("index.json", %{page: page, user_id: user_id}) do
    %{
      chatRooms:
        Enum.map(page.entries, fn room ->
          render_one(%{room: room, user_id: user_id}, SpotChatWeb.RoomView, "room.json")
        end),
      pagination: SpotChatWeb.PaginationHelpers.pagination(page)
    }
  end

  def render("show.json", %{room: room, user_id: user_id}) do
    %{chatRoom: render_one(%{room: room, user_id: user_id}, SpotChatWeb.RoomView, "room.json")}
  end

  def render("room.json", %{room: %{room: room, user_id: user_id}}) do
    %{
      id: room.id,
      name: room.name,
      description: room.description,
      imageSrc: room.image_src,
      private: room.private,
      owned: room.user_id == user_id
    }
  end
end
