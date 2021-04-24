defmodule LouChat.Repo.Migrations.OneUserHasManyLobbies do
  use Ecto.Migration

  def change do
    alter table(:lobbies) do
      add :owner_id, references(:users, type: :uuid)
    end
  end
end
