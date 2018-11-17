defmodule ZaZaar.Repo.Migrations.AddFbOauthFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:fb_id, :string)
      add(:image_url, :string)
      remove(:phone)
      remove(:username)
      add(:name, :string, null: false)

      add(:fb_payload, :map)
    end

    create(index("users", [:fb_id], unique: true))
  end
end
