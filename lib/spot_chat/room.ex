defmodule SpotChat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "rooms" do
    field :name, :string
    field :description, :string
    field :imageSrc, :string
    field :private, :boolean
    has_many :messages, SpotChat.Message

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :description, :imageSrc, :private])
    |> validate_required([:name, :description, :private])
    |> unique_constraint(:name)
  end
end
