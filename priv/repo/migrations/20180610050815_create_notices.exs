defmodule ZaZaar.Repo.Migrations.CreateNotices do
  use Ecto.Migration

  def change do
    create table(:notices, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :uuid), null: false
      add :schema, :map, null: false

      timestamps(updated_at: false)
    end

    create index(:notices, [:user_id])
  end
end
