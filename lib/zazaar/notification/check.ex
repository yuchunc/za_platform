defmodule ZaZaar.Notification.Check do
  use Ecto.Schema
  import Ecto.Changeset

  alias ZaZaar.Account

  @foreign_key_type Ecto.UUID
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "notification_checks" do
    field(:toucher, :boolean, virtual: true)
    belongs_to(:user, Account.User, type: Ecto.UUID)

    timestamps(inserted_at: false)
  end

  def changeset(%__MODULE__{} = check, attrs \\ %{}) do
    check
    |> cast(attrs, [:updated_at])
    |> foreign_key_constraint(:user_id)
  end
end
