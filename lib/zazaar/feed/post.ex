defmodule Zazaar.Feed.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type Ecto.UUID
  @primary_key {:id, :binary_id, autogenerate: true}

  schema "posts" do
    field(:body, :string)
    field(:user_id, Ecto.UUID)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
