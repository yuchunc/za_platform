defmodule ZaZaar.Streaming do
  @moduledoc """
  Streaming Context Module
  """
  import Ecto.Query

  alias ZaZaar.Repo

  alias ZaZaar.Streaming
  alias Streaming.{Stream, Comment}

  def get_streams(opts \\ []) do
    sort_by = Keyword.get(opts, :order_by, [])

    Stream
    |> order_by([s], ^sort_by)
    |> Repo.all()
  end

  def get_stream(uuid) do
    uuid |> IO.inspect(label: "uuid")

    Stream
    |> where(id: ^uuid)
    |> or_where([s], s.streamer_id == ^uuid and is_nil(s.archived_at))
    |> Repo.one()
  end

  def update_stream(stream_id, params) when is_binary(stream_id) do
    Repo.get(Stream, stream_id)
    |> update_stream(params)
  end

  def update_stream(%Stream{archived_at: dt}, _) when dt != nil do
    {:error, :stream_archived}
  end

  def update_stream(%Stream{} = stream, params) do
    stream
    |> Stream.changeset(params)
    |> Repo.update()
  end

  # NOTE maybe this should be create stream
  def start_stream(streamer_id) when is_binary(streamer_id) do
    case get_stream(streamer_id) do
      nil ->
        %Stream{streamer_id: streamer_id}
        |> Stream.changeset(%{})
        |> Repo.insert()

      %Stream{} = stream ->
        {:error, :another_stream_is_active, stream.id}
    end
  end

  def end_stream(uuid) when is_binary(uuid) do
    uuid
    |> get_stream
    |> end_stream
  end

  def end_stream(%Stream{} = stream) do
    stream
    |> Stream.archive()
    |> Repo.update()
  end

  def end_stream(_), do: {:error, :stream_not_found}

  def gen_snapshot_key(stream_id) when is_binary(stream_id) do
    stream_id
    |> get_stream
    |> gen_snapshot_key()
  end

  def gen_snapshot_key(stream) do
    case stream do
      %Stream{} ->
        random_string = :crypto.strong_rand_bytes(Enum.random(8..12)) |> Base.url_encode64()
        result = update_stream(stream, %{upload_key: random_string})

        case result do
          {:ok, _} -> {:ok, random_string}
          _ -> result
        end

      _ ->
        {:error, :stream_not_found}
    end
  end

  def update_snapshot(streamer_id, key, data) when is_binary(streamer_id) do
    streamer_id
    |> get_stream()
    |> update_snapshot(key, data)
  end

  def update_snapshot(%Stream{upload_key: key} = stream, key, data) do
    case result = update_stream(stream, %{upload_key: nil, video_snapshot: data}) do
      {:ok, _} -> :ok
      _ -> result
    end
  end

  def update_snapshot(_, _, _), do: {:error, :stream_not_found}

  def append_comment(%Stream{} = stream0, comment_params) do
    comment = struct(Comment, comment_params)

    {:ok, stream1} =
      stream0
      |> Ecto.Changeset.change()
      |> Stream.put_comment(comment)
      |> Repo.update()

    {:ok, List.first(stream1.comments)}
  end

  def stream_to_facebook(uuid, fb_key, ot_session_id) when is_binary(uuid) do
    uuid
    |> get_stream
    |> stream_to_facebook(fb_key, ot_session_id)
  end

  def stream_to_facebook(%Stream{} = stream, fb_key, ot_session_id) do
    case OpenTok.stream_to_facebook(ot_session_id, stream.streamer_id, fb_key) do
      :ok ->
        update_stream(stream, %{fb_stream_key: fb_key})

      {:error, :noclient} ->
        update_stream(stream, %{fb_stream_key: fb_key})

      response ->
        response
    end
  end
end
