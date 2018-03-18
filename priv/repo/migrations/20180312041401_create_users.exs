defmodule LiveAuction.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :username, :string, null: false
      add :phone, :string, null: false
      add :email, :string, null: false

      timestamps()
    end
  end
end
