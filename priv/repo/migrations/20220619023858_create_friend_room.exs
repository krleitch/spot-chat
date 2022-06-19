defmodule SpotChat.Repo.Migrations.CreateFriendRoom do
  use Ecto.Migration

  def change do
    create table(:friend_room, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :user_id, :uuid, null: false
      add :friend_id, :uuid, null: false

      timestamps()
    end

    create index(:friend_room, [:user_id])
    create index(:friend_room, [:friend_id])
    create index(:friend_room, [:user_id, :friend_id], unique: true)
  end
end
