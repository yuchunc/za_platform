defmodule Facebook.GraphApiTest do
  use ZaZaar.DataCase, async: true

  @moduletag :fb_api

  alias Facebook.GraphApi, as: Api

  describe "request/1" do
    test "it is hitting fb's api" do
      assert {400, %{}} = Api.request("/")
    end

    test "it gets the comments live videos" do
      assert {200, %{"data" => []}} = Api.request("/554311878324637/comments")
    end
  end
end
