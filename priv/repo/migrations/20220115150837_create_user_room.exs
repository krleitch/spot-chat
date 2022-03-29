defmodule SpotChat.Repo.Migrations.CreateUserRoom do
  use Ecto.Migration

  def change do
    create table(:user_room, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :user_id, :uuid, null: false
      add :room_id, references(:room, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create index(:user_room, [:user_id])
    create index(:user_room, [:room_id])
    create index(:user_room, [:user_id, :room_id], unique: true)
  end
end
