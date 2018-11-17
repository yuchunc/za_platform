defmodule ZaZaar.Repo.Migrations.DropChannels do
  use Ecto.Migration

  def change do
    drop(table("channels"))
  end
end
