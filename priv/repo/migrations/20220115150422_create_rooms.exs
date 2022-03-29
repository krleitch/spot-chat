defmodule SpotChat.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :name, :string, null: false
      add :description, :string, default: ""
      add :imageSrc, :string
      add :private, :boolean, null: false, default: false

      timestamps()
    end

    create unique_index(:rooms, [:name])
  end
end
