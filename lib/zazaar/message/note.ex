defmodule ZaZaar.Message.Note do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key nil

  embedded_schema do
    field :user_id, Ecto.UUID
    field :body, :string

    timestamps(update_at: false)
  end

  @doc false
  def changeset(%__MODULE__{} = note, attrs) do
    note
    |> cast(attrs, [:user_id, :body])
    |> validate_required([:user_id, :body])
  end
end
