defmodule ZaZaar.Notification do
  import Ecto.Query

  alias ZaZaar.Notification
  alias Notification.{Notice, Schema}

  @limit 10
  @page 1

  def append_notice(user_id, schema) do
    case Schema.validate(schema) do
      %{valid?: true, changes: payload} -> Notice.append(user_id, payload)
      %{valid?: false} -> {:error, :bad_schema}
    end
  end

  def get_notices(user_id, opts \\ []) do
    page = Keyword.get(opts, :page, @page)

    Notice
    |> where(user_id: ^user_id)
    |> order_by(desc: :inserted_at)
    |> limit(^@limit)
    |> offset(^((page - 1) * @limit))
  end
end
