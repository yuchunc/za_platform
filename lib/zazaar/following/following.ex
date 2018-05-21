defmodule ZaZaar.Following do
  @moduledoc """
  Following Context Module
  """
  import Ecto.Query

  alias ZaZaar.Repo

  alias ZaZaar.Following
  alias Following.Follow

  defguardp is_followable(follower_id, followee_id) when is_binary(follower_id) and is_binary(followee_id)

  def start_following(%{id: some_id}, %{id: some_id}), do: {:error, :cannot_follow_self}

  def start_following(%{id: fan_id}, %{id: target_id}) when is_followable(fan_id, target_id) do
    if Repo.get_by(Follow, follower_id: fan_id, followee_id: target_id) do
      :ok
    else
      result = %Follow{follower_id: fan_id, followee_id: target_id}
               |> Follow.changeset(%{})
               |> Repo.insert

      if {:ok, _} = result do
        :ok
      else
        result
      end
    end
  end

  def start_following(_, _), do: {:error, :no_id_to_record}
end
