defmodule OpenTok do
  @moduledoc """
  This module contains all interaction with OpenTok
  """
  use HTTPoison.Base

  #require Logger

  #@app_config Application.get_env(:opentok, OpenTok)

  #@doc """
  #Creates an OpenTok session
  #"""
  #def create_session(config \\ @app_config) do
    #headers = ["X-OPENTOK-AUTH": jwt(), "Accept": "application/json"]
    #response = HTTPotion.post(@endpoint <> "/session/create", [headers: headers])
    #opentok_process_response(response)
  #end

  #@doc """
  #Generates a JWT for OpenTok
  #"""
  #def jwt do
    #life_length = config(:ttl, 60 * 5)
    #salt = Base.encode16(:crypto.strong_rand_bytes(8))
    #claims = %{
      #iss: config(:key),
      #ist: config(:iss, "project"),
      #iat: :os.system_time(:seconds),
      #exp: :os.system_time(:seconds) + life_length,
      #jti: salt
    #}

    #{_, jwt_string} =
      #nil
      #|> jose_jwk
      #|> JOSE.JWT.sign(jose_jws(%{}), claims)
      #|> JOSE.JWS.compact
      ## { :ok, jwt, full_claims } = Guardian.encode_and_sign("smth", :access, claims)

    #jwt_string
  #end

  #defp opentok_process_response(response) do
    #case response do
      #%{status_code: 200, body: body} ->
        #json = Poison.decode!(body)
        #{:json, json}
      #_ ->
      #Logger.error fn -> "OpenTok query: #{inspect(response)}" end
        #{:error, OpenTok.ApiError}
    #end
  #end
end
