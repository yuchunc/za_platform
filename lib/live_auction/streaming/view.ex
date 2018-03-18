defmodule LiveAuction.Streaming.View do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveAuction.Streaming

  schema "views" do
    field :end_at, :naive_datetime
    field :user_id, Ecto.UUID
    belongs_to :stream_id, Streaming.Streams

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = view, attrs) do
    view
    |> cast(attrs, [:end_at])
    |> validate_required([:end_at])
  end
end
