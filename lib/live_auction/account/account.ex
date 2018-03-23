defmodule LiveAuction.Account do
  @moduledoc """
  Account Context Module
  """

  alias LiveAuction.Repo
  alias LiveAuction.Guardian

  alias LiveAuction.Account
  alias Account.User

  require Logger

  @refresh_token_options [token_type: "refresh", ttl: {2, :week}]
  @access_tokoen_options [token_type: "access", ttl: {10, :minute}]

  def get_user(user_id) do
    Repo.get(User, user_id)
  end

  def authenticate(email, password) do
    with user <- Repo.get_by(User, email: email),
         {:ok, _} <- Comeonin.Argon2.check_pass(user, password),
         {:ok, refresh_token, _} <- Guardian.encode_and_sign(user, %{}, @refresh_token_options),
         {:ok, _, {access_token, _}} <- Guardian.exchange(refresh_token, "refresh", "access", @access_tokoen_options)
    do
      {:ok, {refresh_token, access_token}}
    else
      {:error, message} ->
        Logger.info(message)
        {:error, :invalid_credentials}
      _ -> {:error, :invalid_credentials}
    end
  end
end
