defmodule ZaZaar.Notification do

  alias ZaZaar.Repo
  alias ZaZaar.Notification
  alias Notification.Notice

  def append_notice(action, user_id, schema) do
    %Notice{user_id: user_id}
    |> Notice.changeset(%{schema: Map.put(schema, :type, action)})
    |> Repo.insert
  end
end
