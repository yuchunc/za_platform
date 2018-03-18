defmodule LiveAuction.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveAuction.Account.User

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :username, :string
    field :phone, :string
    field :email, :string

    timestamps()
  end

  @doc """
  Base User changeset
  """
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :phone, :email])
    |> validate_required([:username, :phone, :email])
  end
end
