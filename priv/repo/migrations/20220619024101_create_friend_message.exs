defmodule SpotChat.Repo.Migrations.CreateFriendMessage do
  use Ecto.Migration

  def change do
    create table(:friend_message) do
      add :user_id, :uuid

      timestamps()
    end
  end
end
