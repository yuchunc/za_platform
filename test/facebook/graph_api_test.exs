defmodule Facebook.GraphApiTest do
  use ZaZaar.DataCase, async: true

  @moduletag :fb_api

  alias Facebook.GraphApi, as: Api

  describe "request/1" do
    test "it is hitting fb's api" do
      assert {400, %{}} = Api.request(nil)
    end
  end
end
