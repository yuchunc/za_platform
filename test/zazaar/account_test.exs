defmodule ZaZaar.AccountTest do
  use ZaZaar.DataCase

  alias ZaZaar.Account

  describe "get_user/1" do
    test "gets the respective user" do
      user = insert(:user)

      result = Account.get_user(user.id)

      assert user.id == result.id
    end
  end

  describe "authenticate/2" do
    test "returns :invalid_credential error when bad creds" do
      result = Account.login("bad@email.com", "badpassword")
      assert result == {:error, :invalid_credentials}
    end

    test "generates refresh token and access token from creds" do
      user = insert(:user)

      result = Account.login(user.email, user.password)

      assert {:ok, _refresh_token} = result
    end
  end

  describe "fb_authed/2" do
    setup do
      uid = "10100000000005206"

      info = %Ueberauth.Auth.Info{
        description: nil,
        email: "something@foo.bar",
        first_name: "Mickey",
        image: "http://graph.facebook.com/#{uid}/picture?type=square",
        last_name: "Chen",
        location: nil,
        name: "Mickey Chen",
        nickname: nil,
        phone: nil,
        urls: %{facebook: nil, website: nil}
      }

      {:ok, fb_id: uid, info: info}
    end

    test "creates a user if she doesn't exist in db", context do
      %{info: info, fb_id: fb_id} = context

      assert {:ok, user} = Account.fb_auth(fb_id, info)
      assert user.id
      assert user.encrypted_password
      assert user.fb_payload == Map.from_struct(info)
    end

    test "logs in user if she exist in db", context do
      %{info: info, fb_id: fb_id} = context
      insert(:user, fb_id: fb_id)

      assert {:ok, _} = Account.fb_auth(fb_id, info)
    end
  end
end
