defmodule FacebookTest do
  use ZaZaar.DataCase, async: true

  import Mox

  alias Facebook.GraphApiMock, as: ApiMock
  alias Facebook.Config

  setup :verify_on_exit!

  describe "get_comments/2" do
    setup do
      obj_id = "2054100001268444"
      {:ok, obj_id: obj_id}
    end

    test "gets the comments of a FB object", ctx do
      %{obj_id: obj_id} = ctx

      data = Enum.map(1..25, &comment_stub/1)
      next_url = Config.graph_url() <> "/v3.2/#{obj_id}/comments"

      paging = %{
        "cursors" => %{
          "before" => "before_token",
          "after" => "after_token"
        },
        "next" => next_url
      }

      expect(ApiMock, :request, fn _ ->
        {200, %{"data" => data, "paging" => paging}}
      end)

      assert {:ok, resp} = Facebook.get_comments(obj_id)

      assert Map.has_key?(resp, :data)
      assert Map.has_key?(resp, :paging)

      assert %{cursors: _, next: _} = resp.paging
    end

    test ":error when obj_id is wrong", ctx do
      %{obj_id: obj_id} = ctx

      expect(ApiMock, :request, fn _ ->
        {400,
         %{
           "type" => 100,
           "error" => %{
             "message" => "Unsupported get request. Object with ID '#{obj_id}' does not exist",
             "code" => 100,
             "error_subcode" => 33
           }
         }}
      end)

      assert {:error, :no_fb_obj} = Facebook.get_comments(obj_id)
    end
  end

  defp comment_stub(count) do
    str_count = Integer.to_string(count)

    %{
      "created_time" => NaiveDateTime.utc_now() |> NaiveDateTime.to_iso8601(),
      "message" => "foobar#{count}",
      "id" => "2054192771268444_205436784458427" <> String.pad_leading(str_count, 2, "0")
    }
  end
end
