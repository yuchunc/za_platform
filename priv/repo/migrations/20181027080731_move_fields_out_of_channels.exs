defmodule ZaZaar.Repo.Migrations.MoveFieldsOutOfChannels do
  use Ecto.Migration

  def change do

    alter table(:users) do
      add :ot_session_id, :string
      add :fb_stream_key, :string
    end

    create unique_index(:users, :ot_session_id)
    create unique_index(:users, :fb_stream_key)
  end
end
