defmodule SpotChat.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "user_room" do
    field :user_id, Ecto.UUID
    belongs_to :room, SpotChat.Room, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_room, attrs) do
    user_room
    |> cast(attrs, [:user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> unique_constraint(:user_id_room_id)
  end
end
