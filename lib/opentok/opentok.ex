defmodule OpenTok do
  @moduledoc """
  This module contains all interaction with OpenTok
  """
  use HTTPoison.Base

  alias OpenTok.{Config, Util}

  @token_prefix "T1=="
  @config Util.get_config()
  @ot_api Application.get_env(:live_auction, :ot_api)

  @doc """
  Generates session_id from config
  """
  def request_session_id do
    with jwt <- Util.generate_jwt(@config),
         request_header <- Util.wrap_request_header(jwt),
         {:ok, session_id} <- @ot_api.request_session_id(request_header)
    do
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
    secret = Map.get(@config, :secret)
    key = Map.get(@config, :key)

    data_params = %{
      session_id: session_id,
      role: role,
      nonce: nonce,
      create_time: current_utc_seconds,
      expire_time: current_utc_seconds + (60 * 60 * 24 * 7),
      connection_data: encoded_data
    }

    data_string = URI.encode_query(data_params)

    signed_string = :crypto.hmac(:sha, secret, data_string)
                    |> Base.encode16

    {:ok, @token_prefix <> Base.encode64("partner_id=#{key}&sig=#{signed_string}:#{data_string}")}
  end
end
