defmodule SpotChatWeb.RoomController do
  use SpotChatWeb, :controller

  alias SpotChat.Repo
  alias SpotChat.Room

  def index(conn, _params) do
    rooms = Repo.all(Room)
    render(conn, "index.json", rooms: rooms)
  end

  def create(_conn,  _params) do
    # {:ok, conn}

    # current_user = %{}
    # changeset = Room.changeset(%Room{}, params)

    # case Repo.insert(changeset) do
    #   {:ok, room} ->
    #     assoc_changeset = SpotChat.UserRoom.changeset(
    #       %SpotChat.UserRoom{},
    #       %{user_id: user_id, room_id: room.id}
    #     )
    #     Repo.insert(assoc_changeset)

    #     conn
    #     |> put_status(:created)
    #     |> render("show.json", room: room)
    #   {:error, changeset} ->
    #     conn
    #     |> put_status(:unprocessable_entity)
    #     |> render(SpotChat.ChangesetView, "error.json", changeset: changeset)
    # end
  end

  def join(_conn, %{"id" => _room_id}) do
    # room = Repo.get(Room, room_id)

    # changeset = SpotChat.UserRoom.changeset(
    #   %SpotChat.UserRoom{},
    #   %{room_id: room.id, user_id: user_id}
    # )

    # case Repo.insert(changeset) do
    #   {:ok, _user_room} ->
    #     conn
    #     |> put_status(:created)
    #     |> render("show.json", %{room: room})
    #   {:error, changeset} ->
    #     conn
    #     |> put_status(:unprocessable_entity)
    #     |> render(SpotChat.ChangesetView, "error.json", changeset: changeset)
    # end
  end
end
