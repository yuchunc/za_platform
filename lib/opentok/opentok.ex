defmodule OpenTok do
  @moduledoc """
  This module contains all interaction with OpenTok
  """
  use HTTPoison.Base

  alias OpenTok.Config

  @doc """
  Generates session_id from config
  """
  def create_session do
    with config <- get_config(),
         jwt <- generate_jwt(config),
         request_header <- wrap_request_header(jwt),
         {:ok, response} <- request_session_id(request_header, config)
    do
      response |> IO.inspect(label: "httpoison response")
    end
    # Trake generated JWT for session_id from opentok

    # Format it, catch exceptions
  end

  defp get_config do
    case Config.initialize do
      :ok -> Application.get_env(:live_auction, OpenTok) |> Map.new
      {:error, _} = e -> e
    end
  end

  defp generate_jwt(config) do
    current_utc_seconds = :os.system_time(:seconds)
    secret_jwk = JOSE.JWK.from_oct(config.secret)

    payload = %{
      iss: config.key,
      ist: "project",
      iat: current_utc_seconds,
      exp: current_utc_seconds + 180, # This authentication jwt expires in 3 mins
    }

    {_, jwt} = JOSE.JWT.sign(secret_jwk, %{"alg" => "HS256"}, payload)
               |> JOSE.JWS.compact

    jwt
  end

  defp wrap_request_header(jwt) do
    [
      {"X-OPENTOK-AUTH", jwt},
      {"Accept", "application/json"}
    ]
  end

  defp request_session_id(headers, config) do
    HTTPoison.post(config.endpoint <> "/session/create", "", headers)
  end
end
