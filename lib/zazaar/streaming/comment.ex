defmodule ZaZaar.Streaming.Comment do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :user_id, Ecto.UUID
    field :content, :string

    timestamps(updated_at: false)
  end

  def changeset(%__MODULE__{} = comment, attrs) do
    comment
    |> cast(attrs, [:user_id, :content])
    |> validate_required([:user_id, :content])
  end
end
