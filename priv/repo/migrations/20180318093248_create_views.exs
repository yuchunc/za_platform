defmodule LiveAuction.Repo.Migrations.CreateViews do
  use Ecto.Migration

  def change do
    create table(:views) do
      add :end_at, :naive_datetime
      add :user_id, references(:users, type: :uuid, on_delete: :nothing)
      add :stream_id, references(:streams, type: :uuid, on_delete: :nothing)

      timestamps()
    end

    create index(:views, [:user_id])
    create index(:views, [:stream_id])
  end
end
