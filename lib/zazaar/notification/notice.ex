defmodule ZaZaar.Notification.Notice do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc "append notice to a user_id"
  def append(user_id, payload) do
    Agent.update(__MODULE__, fn state ->
      notices = Map.get(state, user_id, [])
      Map.put(state, user_id, notices ++ [payload])
    end)
  end
end
