defmodule ZaZaar.Notification.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:type, NoticeSchemaEnum)
    field(:from_id, Ecto.UUID)
    field(:content, :string)
  end

  def changeset(%__MODULE__{} = schema, attrs \\ %{}) do
    schema
    |> cast(attrs, [:from_id, :content])
    |> validate_required(:from_id)
    |> validate_schema
  end

  defp validate_schema(changeset) do
    if get_field(changeset, :type) in [:new_message, :new_post] do
      validate_required(changeset, :content)
    else
      changeset
    end
  end
end
