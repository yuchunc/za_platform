defmodule LiveAuction.StreamingTest do
  use LiveAuction.DataCase

  alias LiveAuction.Streaming
  alias Streaming.Stream

  describe "current_stream/1" do
    test "gets the current stream" do
      stream = insert(:stream)

      assert %Stream{} = Streaming.current_stream(stream.streamer_id)
    end
  end
end
