defmodule ZaZaar.Notification.Notice do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc "append notice to a user_id"
  def append(user_id, payload) do
    Agent.update(__MODULE__, fn(state) ->
      notices = Map.get(state, user_id, [])
      Map.put(state, user_id, [payload | notices])
    end)
  end

  def fetch(user_id) do
    Agent.get_and_update(__MODULE__, fn(state) ->
      {Map.get(state, user_id, []), Map.delete(state, user_id)}
    end)
  end

  def count(user_id) do
    Agent.get(__MODULE__, &Map.get(&1, user_id))
    |> Enum.count
  end
end
