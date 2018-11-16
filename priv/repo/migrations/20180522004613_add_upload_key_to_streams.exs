defmodule ZaZaar.Repo.Migrations.AddUploadKeyToStreams do
  use Ecto.Migration

  def change do
    alter table(:streams) do
      add(:upload_key, :string, size: 32)
      add(:video_snapshot, :text)
    end
  end
end
