defmodule Cassius.Facebook.CommentStreamHandler do

  alias Cassius.Facebook
  alias Facebook.Comment
  alias Facebook.CommentStream

  @type comments :: [] | [Comment.t]

  @spec monitor(id::string, opt::keyword) :: comments
  def monitor(stream_id, opts \\ []) do
    CommentStream.start_link(stream_id)
  end
end
