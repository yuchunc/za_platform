defmodule ZaZaar.ChatLogTest do
  use ZaZaar.DataCase

  alias ZaZaar.ChatLog

  describe "append_message/2" do
    test "accepts a list of user_ids, and the message, when history doesn't exist" do
      user_ids = [Ecto.UUID.generate(), Ecto.UUID.generate()]

      msg = %{
        user_id: List.last(user_ids),
        body: "You will never catch me, you will never catch me, lalalalla"
      }

      assert {:ok, history} = ChatLog.append_message(user_ids, msg)

      message = List.last(history.messages)

      assert message.user_id == msg.user_id
      assert message.body == msg.body
    end

    test "accepts a list of user_ids, and the message, and appends to history" do
      history = insert(:history)
      user_id = List.last(history.user_ids)

      msg = %{
        user_id: user_id,
        body: "You will never catch me, you will never catch me, lalalalla"
      }

      assert {:ok, history} = ChatLog.append_message(history.user_ids, msg)

      message = List.last(history.messages)

      assert message.user_id == user_id
      assert message.body == msg.body
    end

    test "errors when engaging conversation with self" do
      user_id = Ecto.UUID.generate()
      user_ids = [user_id, user_id]

      msg = %{
        user_id: user_id,
        body: "You will never catch me, you will never catch me, lalalalla"
      }

      assert {:error, :converse_with_self} = ChatLog.append_message(user_ids, msg)
    end

    test "errors when message user_id is not in user_ids list" do
      user_ids = [Ecto.UUID.generate(), Ecto.UUID.generate()]

      msg = %{
        user_id: Ecto.UUID.generate(),
        body: "You will never catch me, you will never catch me, lalalalla"
      }

      assert {:error, :sender_not_in_chat} = ChatLog.append_message(user_ids, msg)
    end
  end

  describe "get_history/1" do
    setup do
      user_ids = [Ecto.UUID.generate(), Ecto.UUID.generate()]
      messages = build_list(50, :message, user_id: Enum.random(user_ids))
      {:ok, history: insert(:history, messages: messages, user_ids: user_ids)}
    end

    test "gets chat history between 2 people, defualt to 30 messages", context do
      %{history: history} = context

      result = ChatLog.get_history(history.user_ids)

      assert Enum.count(result) == 30
    end

    test "can paginate", context do
      %{history: history} = context

      result = ChatLog.get_history(history.user_ids)
      result_1 = ChatLog.get_history(history.user_ids, page: 2)

      refute result_1 == result
    end

    test "error when chat history is not found" do
      assert {:error, :log_not_found} = ChatLog.get_history(["fake", "boobs"])
    end
  end
end
