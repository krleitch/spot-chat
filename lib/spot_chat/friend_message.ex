defmodule SpotChat.FriendMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "friend_message" do
    field :user_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(friend_message, attrs) do
    friend_message
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
