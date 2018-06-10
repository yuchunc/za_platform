defmodule ZaZaar.Notification.Queue do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type Ecto.UUID
  @primary_key {:id, :binary_id, autogenerate: true}

  alias ZaZaar.Account
  alias ZaZaar.Notification
  alias Notification.Notice

  schema "notification_queues" do
    embeds_many(:notices, Notice)
    belongs_to(:user_id, Account.User)

    timestamps()
  end

  @doc false
  def changeset(queue, attrs) do
    queue
    |> cast(attrs, [])
    |> validate_required([])
  end
end
