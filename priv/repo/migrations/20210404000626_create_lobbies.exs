defmodule LouChat.Repo.Migrations.CreateLobbies do
  use Ecto.Migration

  def change do
    create table(:lobbies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      add :password_hash, :string, null: true
      add :public, :boolean, default: false, null: false

      timestamps()
    end

    create unique_index(:lobbies, [:name])

  end
end
