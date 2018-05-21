defmodule ZaZaar.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :follower_id, :uuid, null: false
      add :followee_id, :uuid, null: false

      timestamps()
    end

  end
end
