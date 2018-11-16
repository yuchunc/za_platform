defmodule ZaZaar.Repo.Migrations.AddStreamerIdToStream do
  use Ecto.Migration

  def change do
    drop_if_exists(index("streams", [:channel_id]))

    alter table(:streams) do
      add(:streamer_id, references(:users, type: :uuid, on_delete: :nothing))
      remove(:channel_id)
    end

    rename(table(:streams), :facebook_stream_key, to: :fb_stream_key)
  end
end
