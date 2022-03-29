defmodule SpotChatWeb.RoomController do
  use SpotChatWeb, :controller

  import Ecto.Query

  alias SpotChat.{Room, Repo}

  def index(conn, params) do
    page =
      SpotChat.Room
      |> order_by(asc: :id)
      |> SpotChat.Repo.paginate(params)

    conn
    |> put_status(:ok)
    |> render("index.json", page: page)
  end

  def create(conn, params) do
    current_user = conn.assigns.current_user
    changeset = Room.changeset(%Room{}, params)

    case Repo.insert(changeset) do
      {:ok, room} ->
        assoc_changeset =
          SpotChat.UserRoom.changeset(
            %SpotChat.UserRoom{},
            %{user_id: current_user.userId, room_id: room.id}
          )

        Repo.insert(assoc_changeset)

        conn
        |> put_status(:created)
        |> render("show.json", room: room)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(SpotChatWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def update(conn, params) do
    room = Repo.get!(Room, params["id"])
    changeset = Room.changeset(room, params)

    case Repo.update(changeset) do
      {:ok, room} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{room: room})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(SpotChatWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def join(conn, %{"id" => room_id}) do
    current_user = conn.assigns.current_user
    room = Repo.get(Room, room_id)

    changeset =
      SpotChat.UserRoom.changeset(
        %SpotChat.UserRoom{},
        %{room_id: room.id, user_id: current_user.userId}
      )

    case Repo.insert(changeset) do
      {:ok, _user_room} ->
        conn
        |> put_status(:created)
        |> render("show.json", %{room: room})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(SpotChatWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end
end
