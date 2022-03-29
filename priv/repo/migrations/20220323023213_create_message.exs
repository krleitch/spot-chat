defmodule SpotChat.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:message, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :user_id, :uuid, null: false
      add :text, :string, null: false
      add :room_id, references(:room, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create index(:message, [:room_id])
    create index(:message, [:user_id])
  end
end
