defmodule ZaZaar.Streaming.Stream do
  use Ecto.Schema
  import Ecto.Changeset

  alias ZaZaar.Streaming

  @foreign_key_type Ecto.UUID
  @primary_key {:id, :binary_id, autogenerate: true}

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
    |> validate_not_archived
  end

  def archive(%__MODULE__{} = stream) do
    stream
    |> changeset(%{archived_at: NaiveDateTime.utc_now()})
    |> validate_required([:archived_at])
  end

  defp validate_not_archived(changeset) do
    if changeset.data.archived_at |> is_nil do
      changeset
    else
      add_error(changeset, :archived_at, "Archived")
    end
  end
end
