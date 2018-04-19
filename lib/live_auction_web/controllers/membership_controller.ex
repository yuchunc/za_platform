defmodule LiveAuctionWeb.MembershipController do
  use LiveAuctionWeb, :controller

  action_fallback FallbackController

  def show(conn, _) do
    with %User{} = user <- current_resource(conn),
         {:ok, stream} <- Streaming.new_session(user.id),
         ot_config <- OpenTok.Util.get_config,
         {:ok, token} <- OpenTok.generate_token(stream.ot_session_id, :publisher, "publisher1"),
         opentok_params <- %{session_id: stream.ot_session_id, token: token, config: ot_config}
    do
      render(conn, "dashboard.html", opentok_params: opentok_params)
    end
  end
end
