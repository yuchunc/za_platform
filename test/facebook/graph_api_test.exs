defmodule Facebook.GraphApiTest do
  use ZaZaar.DataCase, async: true

  @moduletag :fb_api

  alias Facebook.GraphApi, as: Api

  describe "request/1" do
    test "it is hitting fb's api" do
      assert {400, %{}} = Api.request("/")
    end

    test "it gets the comments live videos" do
      response = Api.request("/554311878324637/comments")

      assert {200, %{"data" => data, "paging" => paging}} = response
      assert is_list(data)
      assert Map.has_key?(paging, "cursors")
      assert Map.has_key?(paging, "next")
    end
  end
end
