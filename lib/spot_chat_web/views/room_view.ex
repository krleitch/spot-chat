defmodule SpotChatWeb.RoomView do
  use SpotChatWeb, :view

  def render("index.json", %{page: page, user_id: user_id, lat: lat, lng: lng}) do
    %{
      chatRooms:
        Enum.map(page.entries, fn room ->
          render(
            "room.json",
            %{room: room, user_id: user_id, lat: lat, lng: lng}
          )
        end),
      pagination: SpotChatWeb.PaginationHelpers.pagination(page)
    }
  end

  def render("show.json", %{room: room, user_id: user_id, lat: lat, lng: lng}) do
    %{
      chatRoom:
        render(
          "room.json",
          %{room: room, user_id: user_id, lat: lat, lng: lng}
        )
    }
  end

  # With distance data
  def render("room.json", %{room: room, user_id: user_id, lat: lat, lng: lng}) do
    %{
      id: room.id,
      name: room.name,
      description: room.description,
      imageSrc: room.image_src,
      private: room.password_hash !== nil,
      distance:
        SpotChatWeb.GeoHelpers.distance_between(
          elem(room.point.coordinates, 0),
          elem(room.point.coordinates, 1),
          lng,
          lat
        ),
      geolocation: room.geolocation,
      owned: room.user_id == user_id,
      numUsers: Kernel.map_size(SpotChatWeb.Presence.list("chat_room:" <> room.id)),
      capacity: room.capacity
    }
  end

  # Normal room
  def render("room.json", %{room: room, user_id: user_id}) do
    %{
      id: room.id,
      name: room.name,
      description: room.description,
      imageSrc: room.image_src,
      private: room.password_hash !== nil,
      geolocation: room.geolocation,
      owned: room.user_id == user_id,
      numUsers: Kernel.map_size(SpotChatWeb.Presence.list("chat_room:" <> room.id)),
      capacity: room.capacity
    }
  end
end
