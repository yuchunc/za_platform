defmodule ZaZaar.Notification do
  import Ecto.Query

  alias ZaZaar.Repo
  alias ZaZaar.Notification
  alias Notification.{Notice, Check}

  @limit 10
  @page 1

  def append_notice(user_id, schema) do
    %Notice{user_id: user_id}
    |> Notice.changeset(%{schema: schema})
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

  def last_checked(user_id) do
    case Repo.get_by(Check, user_id: user_id) do
      nil -> NaiveDateTime.utc_now()
      %Check{} = check -> check.updated_at
    end
  end

  def get_notices(user_id, opts \\ []) do
    page = Keyword.get(opts, :page, @page)

    Notice
    |> where(user_id: ^user_id)
    |> order_by(desc: :inserted_at)
    |> limit(^@limit)
    |> offset(^((page - 1) * @limit))
    |> Repo.all()
  end
end
