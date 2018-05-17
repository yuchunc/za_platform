defmodule ZaZaarWeb.StreamingController do
  use ZaZaarWeb, :controller

  action_fallback(FallbackController)

  def show(conn, _params) do
    # to here
    with %User{} = streamer <- current_resource(conn),
         # TODO move this in to WS
         %Channel{} = channel <- Streaming.current_channel_for(streamer.id),
         {:ok, _stream} <- Streaming.start_stream(channel),
         {:ok, key, token} <-
           OpenTok.generate_token(channel.ot_session_id, :publisher, streamer.id),
         opentok_params <- %{session_id: channel.ot_session_id, token: token, key: key} do
      render(conn, "show.html", streamer_id: streamer.id, opentok_params: opentok_params)
    end
  end
end
