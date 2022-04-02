defmodule SpotChatWeb.RoomController do
  use SpotChatWeb, :controller

  import Ecto.Query

  alias SpotChat.{Repo, Room, UserRoom}

  def index(conn, _params) do
    current_user = conn.assigns.current_user

    query = from(r in Room, order_by: [asc: :id])
    page =
      Repo.paginate(
        query,
        cursor_fields: [{:id, :asc}],
        limit: 25
      )

    conn
    |> put_status(:ok)
    |> render("index.json", %{page: page, user_id: current_user.userId})
  end

  def create(conn, params) do
    current_user = conn.assigns.current_user

    changeset =
      Room.changeset(
        %Room{},
        %{
          user_id: current_user.userId,
          name: params["name"],
          description: params["description"],
          image_src: params["imageSrc"],
          private: params["private"]
        }
      )

    case Repo.insert(changeset) do
      {:ok, room} ->
        assoc_changeset =
          UserRoom.changeset(
            %UserRoom{},
            %{user_id: current_user.userId, room_id: room.id}
          )

        Repo.insert(assoc_changeset)

        conn
        |> put_status(:created)
        |> render("show.json", %{room: room, user_id: current_user.userId})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(SpotChatWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  def update(conn, params) do
    current_user = conn.assigns.current_user
    room = Repo.get!(Room, params["id"])
    changeset = Room.changeset(room, params)

    case Repo.update(changeset) do
      {:ok, room} ->
        conn
        |> put_status(:ok)
        |> render("show.json", %{room: room, user_id: current_user.userId})

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
      UserRoom.changeset(
        %UserRoom{},
        %{room_id: room.id, user_id: current_user.userId}
      )

    case Repo.insert(changeset) do
      {:ok, _user_room} ->
        conn
        |> put_status(:created)
        |> render("show.json", %{room: room, user_id: current_user.userId})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(SpotChatWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end
end
