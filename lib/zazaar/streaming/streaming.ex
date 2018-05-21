defmodule ZaZaar.Streaming do
  @moduledoc """
  Streaming Context Module
  """
  import Ecto.Query

  alias ZaZaar.Repo

  alias ZaZaar.Streaming
  alias Streaming.{Channel, Stream}

  def get_channels do
    query = from(s in Channel, order_by: s.updated_at)
    # TODO add active_at and sort on that

    Repo.all(query)
  end

  def current_channel_for(streamer_id) do
    query = from(s in Channel, where: s.streamer_id == ^streamer_id)

    Repo.one(query)
  end

  def create_channel(%{id: streamer_id, tier: :streamer}) do
    {:ok, session_id} = OpenTok.request_session_id()

    %Channel{ot_session_id: session_id, streamer_id: streamer_id}
    |> Repo.insert([])
  end

  def create_channel(_user) do
    {:error, :invalid_user}
  end

  def start_stream(streamer_id) when is_binary(streamer_id) do
    current_channel_for(streamer_id)
    |> start_stream
  end

  def start_stream(%Channel{} = channel) do
    %Stream{}
    |> Stream.changeset(%{channel_id: channel.id})
    |> Repo.insert()
  end

  def start_stream(_), do: {:error, :cannot_start_stream}

  def end_stream(stream_id) when is_binary(stream_id),
    do: Repo.get(Stream, stream_id) |> end_stream

  def end_stream(%Stream{} = stream) do
    stream
    |> Stream.archive()
    |> Repo.update()
  end

  def end_stream(_), do: {:error, :invalid_stream}

  def append_comment(%Stream{} = stream, comment_params) do
    stream
    |> Stream.changeset(%{comments: stream.comments ++ [comment_params]})
    |> Repo.update()
  end
end
