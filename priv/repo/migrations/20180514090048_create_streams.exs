defmodule ZaZaar.Repo.Migrations.CreateStreams do
  use Ecto.Migration

  def change do
    create table(:streams) do
      add :facebook_stream_key, :string
      add :archived_at, :naive_datetime
      add :comments, :jsonb

      timestamps()
    end

    create constraint(:streams, :archived_stream, check: "archived_at ISNULL")
  end
end
