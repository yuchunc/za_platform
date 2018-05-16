defmodule ZaZaar.Streaming.Stream do
  use Ecto.Schema
  import Ecto.Changeset

  alias ZaZaar.Streaming

  schema "streams" do
    field(:facebook_stream_key, :string)
    field(:archived_at, :naive_datetime)

    embeds_many(:comments, Streaming.Comment)

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = stream, attrs) do
    stream
    |> cast(attrs, [:facebook_stream_key, :archived_at])
    |> cast_embed(:comments)
    |> validate_required([])
    |> check_constraint(:archived_at, name: :archived_stream, message: "Stream Archived")
  end
end
