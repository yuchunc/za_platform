defmodule ZaZaar.Streaming.Stream do
  use Ecto.Schema
  import Ecto.Changeset

  alias ZaZaar.Streaming

  schema "streams" do
    field :facebook_stream_key, :string
    field :archived_at, :naive_datetime

    embeds_many :comments, Streaming.Comment

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = stream, attrs) do
    stream
    |> cast(attrs, [:facebook_stream_key, :archived_at])
    |> validate_required([])
  end
end
