defmodule ZaZaar.Notification do
  alias ZaZaar.Notification
  alias Notification.{Notice, Schema}

  def append_notice(user_ids, schema) when is_list(user_ids) do
    Enum.each(user_ids, &append_notice(&1, schema))
  end

  def append_notice(user_id, schema) do
    case Schema.validate(user_id, schema) do
      %{valid?: true, changes: payload} ->
        Notice.append(user_id, payload)
        ZaZaarWeb.Endpoint.broadcast("user:" <> user_id, "notify:new_notice", schema)

      %{valid?: false} ->
        {:error, :notify_error}
    end
  end

  def get_notices(user_id) do
    # page = Keyword.get(opts, :page, @page)
    Notice.fetch(user_id)
  end

  def get_count(user_id) do
    Notice.count(user_id)
  end
end
