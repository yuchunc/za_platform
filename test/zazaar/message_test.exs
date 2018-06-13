defmodule ZaZaar.MessageTest do
  use ZaZaar.DataCase

  alias ZaZaar.Message

  @tag :skip
  describe "append_message/2" do
    test "accepts a list of user_ids, and the message and appends to history" do
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
  end
end
