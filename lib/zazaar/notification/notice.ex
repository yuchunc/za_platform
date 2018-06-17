defmodule ZaZaar.Notification.Notice do
  use Ecto.Schema
  import Ecto.Changeset

  alias ZaZaar.Account
  alias ZaZaar.Notification

  @foreign_key_type Ecto.UUID
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "notices" do
    belongs_to :user, Account.User
    embeds_one(:schema, Notification.Schema)
  end

  def changeset(%__MODULE__{} = struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> cast_embed(:schema)
  end
end
