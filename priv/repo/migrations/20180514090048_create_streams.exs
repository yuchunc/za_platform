defmodule ZaZaar.Repo.Migrations.CreateStreams do
  use Ecto.Migration

  def change do
    create table(:streams, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:facebook_stream_key, :string)
      add(:archived_at, :naive_datetime)
      add(:comments, {:array, :map})

      add(:channel_id, references(:channels, type: :uuid), null: false)

      timestamps()
    end

    create(index(:streams, [:channel_id, :archived_at], unique: true))
  end
end
