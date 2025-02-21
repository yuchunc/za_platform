defmodule ZaZaar.Account do
  @moduledoc """
  Account Context Module
  """

  import Ecto.Query

  alias ZaZaar.Repo

  alias ZaZaar.Account
  alias Account.User

  require Logger

  def get_users(user_ids) when is_list(user_ids) do
    User
    |> where([u], u.id in ^user_ids)
    |> Repo.all()
  end

  def get_user(args) when is_list(args) do
    Repo.get_by(User, args)
  end

  def get_user(user_id) do
    Repo.get(User, user_id)
  end

  def fb_auth(fb_id, info) do
    params = %{
      email: info.email,
      name: info.name,
      fb_id: fb_id,
      password: fb_id,
      image_url: info.image,
      fb_payload: Map.from_struct(info)
    }

    if user = get_user(fb_id: fb_id) do
      {:ok, user}
    else
      create_user(params)
    end
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

  defp create_user(params) do
    {:ok, ot_session_id} = OpenTok.request_session_id()

    %User{ot_session_id: ot_session_id}
    |> User.changeset(params)
    |> Repo.insert()
  end
end
