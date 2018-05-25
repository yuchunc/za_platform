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
    # TODO add active_at and sort on it

    Repo.all(query)
  end

  def get_channel(streamer_id) do
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

  def gen_snapshot_key(%Channel{} = channel) do
    stream =
      channel.id
      |> active_stream_query
      |> Repo.one()

    case stream do
      %Stream{} ->
        random_string = :crypto.strong_rand_bytes(Enum.random(8..12)) |> Base.url_encode64()
        result = Stream.changeset(stream, %{upload_key: random_string}) |> Repo.update()

        case result do
          {:ok, _} -> {:ok, random_string}
          _ -> result
        end

      _ ->
        {:error, :not_found}
    end
  end

  def update_snapshot(channel, key, data) do
    stream =
      channel.id
      |> active_stream_query
      |> where([s], not is_nil(s.upload_key))
      |> where(upload_key: ^key)
      |> Repo.one()

    case stream do
      %Stream{} ->
        result =
          Stream.changeset(stream, %{upload_key: nil, video_snapshot: data}) |> Repo.update()

        case result do
          {:ok, _} -> :ok
          _ -> result
        end

      _ ->
        {:error, :not_found}
    end
  end

  def start_stream(streamer_id) when is_binary(streamer_id) do
    get_channel(streamer_id)
    |> start_stream
  end

  def start_stream(%Channel{} = channel) do
    %Stream{channel_id: channel.id}
    |> Stream.changeset(%{})
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

  defp active_stream_query(channel_id) do
    Stream
    |> where(channel_id: ^channel_id)
    |> where([s], is_nil(s.archived_at))
  end
end
