defmodule OpenTok.Util do
  alias OpenTok.Config

  def generate_jwt(config) do
    current_utc_seconds = :os.system_time(:seconds)
    secret_jwk = JOSE.JWK.from_oct(config.secret)

    payload = %{
      iss: config.key,
      ist: "project",
      iat: current_utc_seconds,
      # This authentication jwt expires in 3 mins
      exp: current_utc_seconds + 180
    }

    JOSE.JWT.sign(secret_jwk, %{"alg" => "HS256"}, payload)
    |> JOSE.JWS.compact()
    |> elem(1)
  end

  def wrap_request_headers(jwt) do
    [
      {"X-OPENTOK-AUTH", jwt},
      {"Accept", "application/json"}
    ]
  end

  def get_config do
    case Config.initialize() do
      :ok -> Application.get_env(:zazaar, OpenTok) |> Map.new()
      {:error, _} = e -> e
    end
  end
end
