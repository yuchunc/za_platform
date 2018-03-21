defmodule LiveAuction.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :username, :string, null: false
      add :encrypted_password, :string, null: false
      add :phone, :string, null: false
      add :email, :string, null: false
      add :tier, :string, null: false, default: "viewer"

      add :refresh_token, :string

      timestamps()
    end

    create unique_index(:users, :username)
    create unique_index(:users, :phone)
    create unique_index(:users, :email)
  end
end
