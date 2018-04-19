defmodule LiveAuction.Streaming do
  @moduledoc """
  Streaming Context Module
  """
  import Ecto.Query

  alias LiveAuction.Repo
  alias LiveAuction.Streaming
  alias Streaming.Stream

  def current_stream(streamer_id) do
    query =
      from s in Stream,
      where: s.streamer_id == ^streamer_id

    Repo.one(query)
  end

  def new_session(streamer_id) do
    case Repo.get_by(Stream, streamer_id: streamer_id) do
      nil ->
        {:ok, session_id} = OpenTok.request_session_id
        %Stream{ot_session_id: session_id}
        |> Repo.insert([])
      stream ->
        {:ok, stream}
    end
  end
end
