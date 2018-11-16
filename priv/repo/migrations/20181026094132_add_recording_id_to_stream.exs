defmodule ZaZaar.Repo.Migrations.AddRecordingIdToStream do
  use Ecto.Migration

  def change do
    alter table("streams") do
      add(:recording_id, :uuid)
    end
  end
end
