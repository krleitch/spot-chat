defmodule SpotChat.FriendMessage do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "friend_message" do
    field :text, :string
    field :user_id, Ecto.UUID
    belongs_to :friend_room_id, SpotChat.FriendRoom, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(friend_message, attrs) do
    friend_message
    |> cast(attrs, [:user_id, :text, :friend_room_id])
    |> validate_required([:user_id, :text, :friend_room_id])
  end
end
