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
