defmodule Facebook do
  @fb_api Application.get_env(:zazaar, :fb_api)

  def get_comments(obj_id, opts \\ []) do
    path = "/" <> obj_id <> "/comments"

    case @fb_api.request(path) do
      {200, resp} ->
        {:ok, format_comments_resp(resp["data"], resp["paging"])}

      {_, e} ->
        %{"error" => %{"message" => msg}} = e
        format_error_msg(msg)
    end
  end

  defp format_comments_resp(data0, paging0) do
    data1 =
      Enum.map(data0, fn comment ->
        %{
          created_time: comment["created_time"],
          message: comment["message"],
          id: comment["id"]
        }
      end)

    paging1 = %{
      cursors: %{
        before: paging0["cursors"]["before"],
        after: paging0["cursors"]["after"]
      },
      next: paging0["next"],
      previous: paging0["previous"]
    }

    %{data: data1, paging: paging1}
  end

  defp format_error_msg(msg) do
    cond do
      Regex.match?(~r/^Unsupported get request. Object with ID '\d*' does not exist/, msg) ->
        {:error, :no_fb_obj}
    end
  end
end
