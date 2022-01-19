defmodule SpotChat.UserRoom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_rooms" do
    field :user_id, :string
    field :room_id, :id

    timestamps()
  end

  @doc false
  def changeset(user_room, attrs) do
    user_room
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id, :room_id])
    |> unique_constraint(:user_id_room_id)
  end
end
