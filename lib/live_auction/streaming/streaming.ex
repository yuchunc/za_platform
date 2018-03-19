defmodule LiveAuction.Streaming do
  @moduledoc """
  Streaming Context
  """
  import Ecto.Query

  alias LiveAuction.Repo
  alias LiveAuction.Streaming
  alias Streaming.Stream

  def current_stream(streamer_id) do
    query =
      from s in Stream,
      where: s.streamer_id == ^streamer_id,
      where: is_nil(s.end_at)

    Repo.one(query)
  end
end
