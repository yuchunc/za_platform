defmodule ZaZaar.Account do
  @moduledoc """
  Account Context Module
  """

  alias ZaZaar.Repo

  alias ZaZaar.Account
  alias Account.User

  require Logger

  def get_user(user_id) do
    Repo.get(User, user_id)
  end

  def login(email, password) do
    with user <- Repo.get_by(User, email: email),
         {:ok, _} <- Comeonin.Argon2.check_pass(user, password) do
      {:ok, user}
    else
      {:error, message} ->
        Logger.info(message)
        {:error, :invalid_credentials}

      _ ->
        {:error, :invalid_credentials}
    end
  end
end
