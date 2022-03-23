defmodule SpotChatWeb.RoomView do
  use SpotChatWeb, :view

  def render("index.json", %{page: page}) do
    %{
      data: render_many(page.entries, SpotChatWeb.RoomView, "room.json"),
      pagination: SpotChatWeb.PaginationHelpers.pagination(page)
    }
  end

  def render("show.json", %{room: room}) do
    %{data: render_one(room, SpotChatWeb.RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{
      id: room.id,
      name: room.name,
      topic: room.topic
    }
  end
end
