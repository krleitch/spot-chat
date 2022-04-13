defmodule SpotChat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "room" do
    field :user_id, Ecto.UUID
    field :name, :string
    field :description, :string
    field :image_src, :string
    field :private, :boolean
    field :point, Geo.PostGIS.Geometry
    has_many :message, SpotChat.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:user_id, :name, :description, :image_src, :private, :point])
    |> validate_required([:user_id, :name, :description, :private, :point])
    |> unique_constraint(:name)
  end
end
