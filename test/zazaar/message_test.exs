defmodule ZaZaar.MessageTest do
  use ZaZaar.DataCase

  alias ZaZaar.Message

  describe "append_message/2" do
    test "accepts a list of user_ids, and the message, when history doesn't exist" do
      user_ids = [Ecto.UUID.generate(), Ecto.UUID.generate()]

      msg = %{
        user_id: List.last(user_ids),
        body: "You will never catch me, you will never catch me, lalalalla"
      }

      assert {:ok, history} = Message.append_message(user_ids, msg)

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

      assert {:ok, history} = Message.append_message(history.user_ids, msg)

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

      assert {:error, :converse_with_self} = Message.append_message(user_ids, msg)
    end

    test "errors when message user_id is not in user_ids list" do
      user_ids = [Ecto.UUID.generate(), Ecto.UUID.generate()]

      msg = %{
        user_id: Ecto.UUID.generate(),
        body: "You will never catch me, you will never catch me, lalalalla"
      }

      assert {:error, :sender_not_in_chat} = Message.append_message(user_ids, msg)
    end
  end

  @tag :skip
  describe "retrieve_history/1" do
    test "gets chat history between 2 people" do
    end

    test "default to 30" do
    end

    test "can paginate" do
    end

    test "error when chat history is not found" do
    end
  end
end
