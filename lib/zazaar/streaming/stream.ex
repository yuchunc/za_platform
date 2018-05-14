defmodule ZaZaar.Streaming.Stream do
  use Ecto.Schema
  import Ecto.Changeset
  alias ZaZaar.Streaming.Stream


  schema "streams" do
    field :facebook_stream_key, :string
    field :archived_at, :naive_datetime

    field :comments, {:array, :map}

    timestamps()
  end

  @doc false
  def changeset(%Stream{} = stream, attrs) do
    stream
    |> cast(attrs, [])
    |> validate_required([])
  end
end
