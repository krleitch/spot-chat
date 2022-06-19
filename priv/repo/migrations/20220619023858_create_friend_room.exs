defmodule SpotChat.Repo.Migrations.CreateFriendRoom do
  use Ecto.Migration

  def change do
    create table(:friend_room) do
      add :user_id, :uuid

      timestamps()
    end
  end
end
