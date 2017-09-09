defmodule Cassius.Facebook.Stream do
  use Ecto.Schema

  alias Cassius.Facebook

  @primary_key false

  embedded_schema do
    field :stream_id, :string
    embeds_many :comments, Facebook.Comment
  end
end
