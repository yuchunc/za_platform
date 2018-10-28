defmodule ZaZaar.Repo.Migrations.AddStreamerIdToStream do
  use Ecto.Migration

  def change do
    alter table(:streams) do
      add :streamer_id, references(:users, type: :uuid, on_delete: :nothing)
      modify :channel_id, :uuid, null: true
    end
  end
end
