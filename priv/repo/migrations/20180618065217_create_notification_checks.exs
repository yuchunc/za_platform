defmodule ZaZaar.Repo.Migrations.CreateNotificationChecks do
  use Ecto.Migration

  def change do
    create table(:notification_checks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid, on_delete: :nothing), null: false

      timestamps(inserted_at: false)
    end

    create index(:notification_checks, [:user_id])
  end
end
