defmodule LiveAuction.Account do
  @moduledoc """
  Account Context Module
  """

  alias LiveAuction.Repo
  alias LiveAuction.Account
  alias Account.User

  def get_user(user_id) do
    Repo.get(User, user_id)
  end
end
