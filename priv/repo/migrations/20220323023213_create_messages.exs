defmodule SpotChat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :user_id, :string, null: false
      add :text, :string, null: false
      add :room_id, references(:rooms, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:messages, [:room_id])
  end
end
