defmodule Cassius.Facebook.Comment do
  use Ecto.Schema
  #import Ecto.Changeset
  #alias Cassius.Facebook.Comment

  @primary_key false

  embedded_schema do

    timestamps()
  end

  #@doc false
  #def changeset(%Comment{} = comment, attrs) do
    #comment
    #|> cast(attrs, [])
    #|> validate_required([])
  #end
end
