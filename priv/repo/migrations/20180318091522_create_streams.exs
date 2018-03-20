defmodule LiveAuction.Repo.Migrations.CreateStreams do
  use Ecto.Migration

  def change do
    create table(:streams, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :ot_session_id, :string, null: false
      add :end_at, :naive_datetime
      add :social_links, :map

      add :streamer_id, references(:users, type: :uuid, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:streams, :ot_session_id)
    create unique_index(:streams, :end_at, where: "end_at = null")
  end
end
