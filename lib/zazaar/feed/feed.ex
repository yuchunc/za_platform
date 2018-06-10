defmodule ZaZaar.Feed do
  import Ecto.Query

  alias ZaZaar.Repo

  alias ZaZaar.Feed
  alias Feed.Post

  @doc """
  gets a list of feed, default to order by desc
  """
  def get_feed(user_id) do
    Post
    |> where(user_id: ^user_id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  adds a post of the user feed
  """
  def add_post(user_id, content) do
    %Post{user_id: user_id}
    |> Post.changeset(%{body: content})
    |> Repo.insert()
  end
end
