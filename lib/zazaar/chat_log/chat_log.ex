defmodule ZaZaar.ChatLog do
  import Ecto.Changeset

  alias ZaZaar.Repo

  alias ZaZaar.ChatLog
  alias ChatLog.{History, Message}

  def append_message([user_id, user_id], _) do
    {:error, :converse_with_self}
  end

  def append_message([user1_id, user2_id], %{user_id: user_id})
      when user_id not in [user1_id, user2_id] do
    {:error, :sender_not_in_chat}
  end

  def append_message(user_ids, attrs) do
    history =
      case Repo.get_by(History, user_ids: user_ids) do
        nil -> %History{user_ids: user_ids}
        history -> history
      end

    msg = struct(Message, attrs)

    history
    |> History.changeset()
    |> put_embed(:messages, history.messages ++ [msg])
    |> Repo.insert_or_update()
  end
end
