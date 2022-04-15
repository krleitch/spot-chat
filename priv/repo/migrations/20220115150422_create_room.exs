defmodule SpotChat.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    create table(:room, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :user_id, :uuid, null: false
      add :name, :string, null: false
      add :description, :string, default: ""
      add :image_src, :string
      add :password_hash, :string
      add :point, :geometry
      add :geolocation, :string, default: ""
      add :capacity, :integer, default: 50

      timestamps()
    end

    create unique_index(:room, [:name])
  end

  def down do
    drop(table(:room))
    execute "DROP EXTENSION IF EXISTS postgis"
  end
end
