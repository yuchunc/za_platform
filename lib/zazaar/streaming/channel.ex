defmodule ZaZaar.Streaming.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "channels" do
    field(:ot_session_id, :string)
    field(:streamer_id, Ecto.UUID)

    timestamps()
  end

  @doc """
  Stream Base Changeset
  """
  def changeset(%__MODULE__{} = stream, attrs) do
    stream
    |> cast(attrs, [])
    |> validate_required([:ot_session_id])
    |> unique_constraint(:ot_session_id)
    |> foreign_key_constraint(:stream_id)
  end
end
