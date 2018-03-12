defmodule OpenTok do
  @moduledoc """
  This module contains all interaction with OpenTok
  """
  use HTTPoison.Base

  alias OpenTok.Config

  @token_prefix "T1=="

  @doc """
  Generates session_id from config
  """
  def create_session do
    with config <- get_config(),
         jwt <- generate_jwt(config),
         request_header <- wrap_request_header(jwt),
         {:ok, response} <- request_session_id(request_header, config)
    do
      [%{"session_id" => session_id}] = response
      {:ok, session_id}
    end
  end

  @doc """
  Generats a OpenTok valid token
  """
  def generate_token(session_id, role, data \\ "") do
    nonce = :crypto.strong_rand_bytes(16) |> Base.encode16
    encoded_data = URI.encode(data)
    current_utc_seconds = :os.system_time(:seconds)
    secret = Application.get_env(:live_auction, OpenTok) |> Map.get(:secret)
    key = Application.get_env(:live_auction, OpenTok) |> Map.get(:key)

    data_params = %{
      session_id: session_id,
      role: role,
      nonce: nonce,
      create_time: current_utc_seconds,
      connection_data: encoded_data
    }

    data_string = URI.encode_query(data_params)

    signed_string = :crypto.hmac(:sha, secret, data_string)
                    |> Base.encode16

    {:ok, @token_prefix <> Base.encode64("partner_id=#{key}&sig=#{signed_string}:#{data_string}")}
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
    {:ok, response} = HTTPoison.post(config.endpoint <> "/session/create", [], headers)

    case response.status_code do
      403 -> {:error, "Authentication failed while creating a session."}
      sc when sc in 200..300 -> Poison.decode(response.body)
      sc -> {:error, "Failed to create session. Response code: #{sc}"}
    end
  end
end
