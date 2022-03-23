defmodule SpotChat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :text, :string
    field :user_id, :string
    belongs_to :room, SpotChat.Room

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user_id, :text, :room_id])
    |> validate_required([:text, :user_id, :room_id])
  end
end
