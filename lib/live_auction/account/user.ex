defmodule LiveAuction.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveAuction.Account.User

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :username, :string
    field :phone, :string
    field :email, :string

    field :tier, UserTierEnum

    timestamps()
  end

  @doc """
  Base User changeset
  """
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :phone, :email])
    |> validate_required([:username, :phone, :email])
    |> unique_constraint(:username)
    |> unique_constraint(:phone)
    |> unique_constraint(:email)
  end
end
