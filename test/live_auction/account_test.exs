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

  describe "authenticate/2" do
    test "returns :invalid_credential error when bad creds" do
       result = Account.authenticate("bad@email.com", "badpassword")
       assert result == {:error, :invalid_credentials}
    end

    test "generates refresh token and access token from creds" do
      user = insert(:user)

      result = Account.authenticate(user.email, user.password)

      assert {:ok, _refresh_token} = result
    end
  end
end
