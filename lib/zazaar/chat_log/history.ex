defmodule ZaZaar.ChatLog.History do
  use Ecto.Schema
  import Ecto.Changeset

  alias ZaZaar.ChatLog

  @foreign_key_type :uuid
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "message_histories" do
    # FIXME this should be {:array, :uuid}, but is causing problem
    field(:user_ids, {:array, :string})
    embeds_many(:messages, ChatLog.Message)

    timestamps()
  end

  @doc false
  def changeset(history, attrs \\ %{}) do
    history
    |> cast(attrs, [])
    |> cast_embed(:messages)
    |> validate_required([:user_ids, :messages])
  end
end
