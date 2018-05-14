defmodule ZaZaar.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field(:username, :string)
    field(:phone, :string)
    field(:email, :string)
    field(:tier, UserTierEnum)

    field(:encrypted_password, :string)
    field(:password, :string, virtual: true)

    field(:refresh_token, :string)

    timestamps()
  end

  @doc """
  Base User changeset
  """
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:username, :phone, :email, :password])
    |> validate_required([:username, :phone, :email])
    |> validate_and_encrypt_password
    |> unique_constraint(:username)
    |> unique_constraint(:phone)
    |> unique_constraint(:email)
  end

  def refresh_token_changeset(%__MODULE__{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:refresh_token])
    |> validate_required([:refresh_token])
  end

  defp validate_and_encrypt_password(changeset) do
    case password = get_change(changeset, :password) do
      nil ->
        changeset

      _ ->
        changeset
        |> validate_length(:password, min: 6)
        |> put_change(:encrypted_password, Comeonin.Argon2.hashpwsalt(password))
    end
  end
end
