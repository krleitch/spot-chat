defmodule SpotChat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "message" do
    field :text, :string
    field :user_id, Ecto.UUID
    belongs_to :room, SpotChat.Room, type: Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user_id, :text, :room_id])
    |> validate_required([:text, :user_id, :room_id])
  end
end
