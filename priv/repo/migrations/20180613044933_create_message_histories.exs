defmodule ZaZaar.Repo.Migrations.CreateMessageHistories do
  use Ecto.Migration

  def change do
    create table(:message_histories, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_ids, {:array, :map}, nil: false
      add :messages, {:array, :map}, nil: false

      timestamps()
    end

    create index(:message_histories, ["user_ids"])
  end
end
