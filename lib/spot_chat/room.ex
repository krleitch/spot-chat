defmodule SpotChat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  schema "room" do
    field :user_id, Ecto.UUID
    field :name, :string
    field :description, :string
    field :image_src, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :point, Geo.PostGIS.Geometry
    has_many :message, SpotChat.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:user_id, :name, :description, :image_src, :point])
    |> validate_required([:user_id, :name, :point])
    |> validate_length(:name, min: 3, max: 64)
    |> validate_length(:description, min: 0, max: 256)
    |> unique_constraint(:name)
  end

  def registration_changeset(room, attrs) do
    room
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_length(:password, min: 3, max: 64)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Argon2.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
