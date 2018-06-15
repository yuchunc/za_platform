defmodule ZaZaar.ChatLog.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :uuid
  @primary_key {:id, :binary_id, autogenerate: true}

  embedded_schema do
    field(:user_id, Ecto.UUID)
    field(:body, :string)

    timestamps(update_at: false)
  end

  @doc false
  def changeset(%__MODULE__{} = note, attrs \\ %{}) do
    note
    |> cast(attrs, [:user_id, :body])
    |> validate_required([:user_id, :body])
  end
end
