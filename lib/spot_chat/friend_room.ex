defmodule SpotChat.FriendRoom do
  use Ecto.Schema
  import Ecto.Changeset

  schema "friend_room" do
    field :user_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(friend_room, attrs) do
    friend_room
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
