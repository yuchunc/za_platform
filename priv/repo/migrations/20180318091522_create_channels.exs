defmodule ZaZaar.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :ot_session_id, :string, null: false
      add :facebook_stream_key, :string
      add :streamer_id, references(:users, type: :uuid, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:channels, :ot_session_id)
    create unique_index(:channels, :facebook_stream_key)
  end
end
