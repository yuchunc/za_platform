defmodule LiveAuction.Streaming.Stream do
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveAuction.Streaming.Stream


  schema "streams" do
    field :ot_session_id, :string
    field :end_at, :naive_datetime

    field :social_links, :map

    timestamps()
  end

  @doc """
  Stream Base Changeset
  """
  def changeset(%Stream{} = stream, attrs) do
    stream
    |> cast(attrs, [:end_at, :social_links])
    |> validate_required([:ot_session_id, :end_at, :social_links])
  end
end
