defmodule OpenTok.ApiMock do
  @behaviour OpenTok.Behaviour

  def create_session(_, _) do
    {:ok, good_session_response()}
  end

  defp good_session_response() do
    %HTTPoison.Response{
      body: "[{\"properties\":null,\"session_id\":\"1_MX40NjA3NDA1Mn5-MTUyMzg2Njg0NjIzN35LNjFOVkI3RWR6M2U3dUw4aXZyQ1hOU3B-fg\",\"project_id\":\"46074052\",\"partner_id\":\"46074052\",\"create_dt\":\"Mon Apr 16 01:20:46 PDT 2018\",\"session_status\":null,\"status_invalid\":null,\"media_server_hostname\":null,\"messaging_server_url\":null,\"messaging_url\":null,\"symphony_address\":null,\"ice_server\":null,\"ice_servers\":null,\"ice_credential_expiration\":86100}]",
      headers: [
        {"Server", "nginx"},
        {"Date", "Mon, 16 Apr 2018 08:20:46 GMT"},
        {"Content-Type", "application/json"},
        {"Connection", "keep-alive"},
        {"Access-Control-Allow-Origin", "*"},
        {"Content-Length", "417"},
        {"Strict-Transport-Security", "max-age=31536000; includeSubdomains"}
      ],
      request_url: "https://api.opentok.com/session/create",
      status_code: 200
    }
  end
end
