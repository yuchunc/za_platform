defmodule Cassius.Facebook.CommentStream do
  use GenServer

  alias Cassius.Facebook
  alias Facebook.CommentStreamHandler
  alias Facebook.RequestObject

  @type on_start :: GenServer.on_start

  @spec start_link(stream_id::String.t) :: on_start
  def start_link(stream_id) do
    GenServer.start_link(__MODULE__, %{stream_id: stream_id})
  end

  def init(state) do
    schedule_api_call()
    {:ok, state}
  end

  def handle_info(:get_comments, %{stream_id: stream_id}=state) do
    build(:get_comments, stream_id)
    |> IO.inspect
    schedule_api_call()
    {:noreply, state}
  end

  defp schedule_api_call() do
    Process.send_after(self(), :get_comments, 1100)
  end

  def build(:get_comments, stream_id) do
    %RequestObject{
      method: "GET",
      relative_url: "v2.10/#{stream_id}/comments"
    }
  end
end

