defmodule ZaZaar.Notification.Schema do
  @moduledoc """
  This is the schema validation module for notifications
  """

  import Ecto.Changeset

  @types %{
    type: NoticeSchemaEnum,
    from_id: Ecto.UUID,
    content: :string,
    at: :datetime
  }

  def validate(attrs) do
    {%{}, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:from_id, :type])
    |> validate_inclusion(:type, NoticeSchemaEnum.__valid_values__)
    |> validate_schema
    |> put_change(:at, NaiveDateTime.utc_now)
  end

  defp validate_schema(changeset) do
    if get_field(changeset, :type) in [:new_message, :new_post] do
      validate_required(changeset, :content)
    else
      changeset
    end
  end
end
