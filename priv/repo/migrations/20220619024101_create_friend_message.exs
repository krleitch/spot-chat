defmodule SpotChat.Repo.Migrations.CreateFriendMessage do
  use Ecto.Migration

  def change do
    create table(:friend_message, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :user_id, :uuid, null: false
      add :text, :string, null: false
      add :friend_room_id, references(:friend_room, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create index(:friend_message, [:friend_room_id])
    create index(:friend_message, [:user_id])
  end
end
