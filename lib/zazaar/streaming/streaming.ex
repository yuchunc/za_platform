defmodule ZaZaar.Streaming do
  @moduledoc """
  Streaming Context Module
  """
  import Ecto.Query

  alias ZaZaar.Repo

  alias ZaZaar.Streaming
  alias Streaming.{Stream, Comment}

  # def get_channels(opts \\ []) do
  #   with_snapshot = Keyword.get(opts, :snapshot, false)
  #   query0 = from(c in Channel, order_by: c.updated_at)
  #   # TODO add active_at and sort on it

  #   query1 =
  #     if with_snapshot do
  #       query0
  #       |> join(:inner, [c], s in Stream, c.id == s.channel_id and is_nil(s.archived_at))
  #       |> select([c, s], %{c | video_snapshot: s.video_snapshot})
  #     else
  #       query0
  #     end

  #   Repo.all(query1)
  # end

  # def get_channel(streamer_id) do
  #   query = from(s in Channel, where: s.streamer_id == ^streamer_id)

  #   Repo.one(query)
  # end

  def get_stream(uuid) do
    Stream
    |> where(id: ^uuid)
    |> or_where([s], s.streamer_id == ^uuid and is_nil(s.archived_at))
    |> Repo.one()
  end

  def update_stream(stream_id, params) when is_binary(stream_id) do
    Repo.get(Stream, stream_id)
    |> update_stream(params)
  end

  def update_stream(%Stream{} = stream, params) do
    stream
    |> Stream.changeset(params)
    |> Repo.update()
  end

  def start_stream(channel) do
    case get_stream(channel) do
      nil ->
        %Stream{channel_id: channel.id}
        |> Stream.changeset(%{})
        |> Repo.insert()

      %Stream{} ->
        {:error, :another_stream_is_active}
    end
  end

  def start_stream(_), do: {:error, :cannot_start_stream}

  def end_stream(channel) do
    if stream = active_stream_query(channel.id) |> Repo.one() do
      stream
      |> Stream.archive()
      |> Repo.update()
    else
      end_stream(nil)
    end
  end

  def end_stream(_), do: {:error, :invalid_channel}

  def find_or_create_channel(%{id: streamer_id}) do
    if channel = Repo.get_by(Channel, streamer_id: streamer_id) do
      channel
    else
      {:ok, session_id} = OpenTok.request_session_id()

      %{ot_session_id: session_id, streamer_id: streamer_id}
      |> Repo.insert([])
    end
  end

  def find_or_create_channel(_user) do
    {:error, :invalid_user}
  end

  def gen_snapshot_key(channel) do
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

  def update_snapshot(streamer_id, key, data) when is_binary(streamer_id) do
    streamer_id
    |> get_stream()
    |> update_snapshot(key, data)
  end

  def update_snapshot(channel, key, data) do
    channel
    |> get_stream()
    |> update_snapshot(key, data)
  end

  def update_snapshot(%Stream{upload_key: key} = stream, key, data) do
    case result =
           Stream.changeset(stream, %{upload_key: nil, video_snapshot: data}) |> Repo.update() do
      {:ok, _} -> :ok
      _ -> result
    end
  end

  def update_snapshot(_, _, _), do: {:error, :not_found}

  def append_comment(%Stream{} = stream0, comment_params) do
    comment = struct(Comment, comment_params)

    {:ok, stream1} =
      stream0
      |> Ecto.Changeset.change()
      |> Stream.put_comment(comment)
      |> Repo.update()

    {:ok, List.first(stream1.comments)}
  end

  def stream_to_facebook(%{facebook_key: nil}), do: nil

  def stream_to_facebook(%{} = channel) do
    OpenTok.stream_to_facebook(channel.ot_session_id, channel.streamer_id, channel.facebook_key)
  end

  defp active_stream_query(%{} = channel), do: active_stream_query(channel.id)

  defp active_stream_query(channel_id) do
    Stream
    |> where(channel_id: ^channel_id)
    |> where([s], is_nil(s.archived_at))
  end
end
