defmodule ZaZaar.Repo.Migrations.CreateNotificationQueues do
  use Ecto.Migration

  def change do
    create table(:notification_queues) do
      add :user_id, references(:users, on_delete: :nothing, type: :uuid), null: false
      add :notices, {:array, :map}

      timestamps()
    end

    create index(:notification_queues, [:user_id])
  end
end
