defmodule ZaZaar.Streaming do
  @moduledoc """
  Streaming Context Module
  """
  import Ecto.Query

  alias ZaZaar.Repo
  alias ZaZaar.Streaming
  alias Streaming.Stream

  def get_streams do
    query = from(s in Stream, order_by: s.updated_at)
    # TODO add active_at and sort on that

    Repo.all(query)
  end

  def current_stream_for(streamer_id) do
    query = from(s in Stream, where: s.streamer_id == ^streamer_id)

    Repo.one(query)
  end

  def new_session(streamer_id) do
    case Repo.get_by(Stream, streamer_id: streamer_id) do
      nil ->
        {:ok, session_id} = OpenTok.request_session_id()

        %Stream{ot_session_id: session_id}
        |> Repo.insert([])

      stream ->
        {:ok, stream}
    end
  end
end
