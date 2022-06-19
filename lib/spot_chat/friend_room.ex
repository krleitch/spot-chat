defmodule SpotChat.FriendRoom do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "friend_room" do
    field :user_id, Ecto.UUID
    field :friend_id, Ecto.UUID
    has_many :friend_message, SpotChat.FriendMessage

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(friend_room, attrs) do
    friend_room
    |> cast(attrs, [:user_id, :friend_id])
    |> validate_required([:user_id, :friend_id])
  end
end
