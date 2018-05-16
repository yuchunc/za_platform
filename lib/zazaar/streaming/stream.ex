defmodule ZaZaar.Streaming.Stream do
  use Ecto.Schema
  import Ecto.Changeset

  alias ZaZaar.Streaming

  @foreign_key_type Ecto.UUID

  schema "streams" do
    field(:facebook_stream_key, :string)
    field(:archived_at, :naive_datetime)

    belongs_to(:channel, Streaming.Channel)

    embeds_many(:comments, Streaming.Comment)

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = stream, attrs) do
    stream
    |> cast(attrs, [:facebook_stream_key, :archived_at, :channel_id])
    |> cast_embed(:comments)
    |> assoc_constraint(:channel)
    |> check_constraint(:archived_at, name: :archived_stream, message: "Stream Archived")
  end
end
