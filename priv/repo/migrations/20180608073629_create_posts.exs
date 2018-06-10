defmodule ZaZaar.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :body, :text
      add :user_id,
        references(:users, on_delete: :nothing, type: :uuid) ,
        null: false

      timestamps()
    end

    create index(:posts, [:user_id])
  end
end
