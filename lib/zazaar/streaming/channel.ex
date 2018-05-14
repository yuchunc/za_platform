defmodule ZaZaar.Streaming.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "channels" do
    field(:ot_session_id, :string)
    field(:facebook_stream_key, :string)
    field(:streamer_id, Ecto.UUID)

    timestamps()
  end

  @doc """
  Stream Base Changeset
  """
  def changeset(%__MODULE__{} = stream, attrs) do
    stream
    |> cast(attrs, [:facebook_stream_key])
    |> validate_required([:ot_session_id])
    |> unique_constraint(:ot_session_id)
    |> unique_constraint(:facebook_stream_key)
    |> foreign_key_constraint(:stream_id)
  end
end
