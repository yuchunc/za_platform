defmodule ZaZaar.ChatLog do
  import Ecto.Changeset
  import Ecto.Query

  alias ZaZaar.Repo

  alias ZaZaar.ChatLog
  alias ChatLog.{History, Message}

  @limit 30
  @page 1

  def append_message([user_id, user_id], _) do
    {:error, :converse_with_self}
  end

  def append_message([user1_id, user2_id], %{user_id: user_id})
      when user_id not in [user1_id, user2_id] do
    {:error, :sender_not_in_chat}
  end

  def append_message(user_ids, attrs) do
    history =
      case do_get_history(user_ids) do
        nil -> %History{user_ids: user_ids}
        history -> history
      end

    msg = struct(Message, attrs)

    history
    |> History.changeset()
    |> put_embed(:messages, history.messages ++ [msg])
    |> Repo.insert_or_update()
  end

  def get_history(user_ids, opts \\ []) do
    limit = Keyword.get(opts, :limit, @limit)
    page = Keyword.get(opts, :page, @page)

    if history = do_get_history(user_ids) do
      {result, _} =
        history
        |> Map.get(:messages)
        |> Enum.reverse()
        |> Enum.chunk_every(limit)
        |> List.pop_at(page - 1)

      case result do
        nil -> []
        _ -> result
      end
    else
      {:error, :log_not_found}
    end
  end

  defp do_get_history(user_ids) do
    History
    |> where(fragment("user_ids @> ?", ^user_ids))
    |> Repo.one()
  end
end
