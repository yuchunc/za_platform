defmodule LiveAuctionWeb.StreamingController do
  use LiveAuctionWeb, :controller

  action_fallback FallbackController

  def show(conn, _params) do
    with %User{} = user <- current_resource(conn),
         {:ok, stream} <- Streaming.new_session(user.id),
         {:ok, _key, token} <- OpenTok.generate_token(stream.ot_session_id, :publisher, "publisher1"),
         ot_config <- OpenTok.Util.get_config,
         opentok_params <- %{session_id: stream.ot_session_id, token: token, config: ot_config}
    do
      render(conn, "show.html", opentok_params: opentok_params)
    end
  end
end
