defmodule ZaZaar.Following.Follow do
  use Ecto.Schema
  import Ecto.Changeset


  schema "follows" do
    field :followee_id, Ecto.UUID
    field :follower_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = follow, attrs) do
    follow
    |> cast(attrs, [])
    |> validate_required([:follower_id, :followee_id])
  end
end
