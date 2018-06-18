defmodule ZaZaar.Notification do
  alias ZaZaar.Repo
  alias ZaZaar.Notification
  alias Notification.{Notice, Check}

  def append_notice(action, user_id, schema) do
    %Notice{user_id: user_id}
    |> Notice.changeset(%{schema: Map.put(schema, :type, action)})
    |> Repo.insert()
  end

  def check(user_id) do
    check =
      case Repo.get_by(Check, user_id: user_id) do
        nil -> %Check{user_id: user_id}
        check -> check
      end

    {:ok, check} =
      Check.changeset(check, %{updated_at: NaiveDateTime.utc_now()})
      |> Repo.insert_or_update()

    {:ok, check.updated_at}
  end
end
