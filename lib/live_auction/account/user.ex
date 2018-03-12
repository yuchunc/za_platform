defmodule LiveAuction.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveAuction.Account.User

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [])
    |> validate_required([])
  end
end
