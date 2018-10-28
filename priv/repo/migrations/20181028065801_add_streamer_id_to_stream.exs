defmodule ZaZaar.Repo.Migrations.AddStreamerIdToStream do
  use Ecto.Migration

  def change do
    alter table(:streams) do
      add :streamer_id, references(:users, type: :uuid, on_delete: :nothing)
    end
  end
end
