defmodule LiveAuction.AccountTest do
  use LiveAuction.DataCase, async: true

  alias LiveAuction.Account

  describe "get_user/1" do
    test "gets the respective user" do
      user = insert(:user)

      result = Account.get_user(user.id)

      assert user.id == result.id
    end
  end
end
