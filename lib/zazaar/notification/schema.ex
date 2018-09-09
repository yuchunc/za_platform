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

  def validate(user_id, attrs) do
    {%{}, @types}
    |> cast(attrs, Map.keys(@types))
    |> put_change(:at, NaiveDateTime.utc_now())
    |> validate_required([:from_id, :type, :at])
    |> validate_inclusion(:type, NoticeSchemaEnum.__valid_values__())
    |> validate_schema
    |> validate_notify_self(user_id)
  end

  defp validate_schema(changeset) do
    if get_field(changeset, :type) in [:new_message, :new_post] do
      validate_required(changeset, :content)
    else
      changeset
    end
  end

  defp validate_notify_self(changeset, user_id) do
    if get_field(changeset, :from_id) == user_id do
      add_error(changeset, :from_id, "cannot notify self")
    else
      changeset
    end
  end
end
