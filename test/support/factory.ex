defmodule ZaZaar.Factory do
  use ExMachina.Ecto, repo: ZaZaar.Repo

  alias ZaZaar.{Account, Streaming, Following, Feed, ChatLog}

  # ====== Account =========
  def user_factory do
    password = "12345678"

    %Account.User{
      # username: sequence(Faker.Internet.user_name()),
      name: Faker.Name.name(),
      email: Faker.Internet.email(),
      password: password,
      encrypted_password: Comeonin.Argon2.hashpwsalt(password)
    }
  end

  # ====== Streaming =========
  def stream_factory do
    user = insert(:user)

    %Streaming.Stream{
      streamer_id: user.id
    }
  end

  def comment_factory do
    user = insert(:user)

    %Streaming.Comment{
      user_id: user.id,
      content: Faker.Lorem.sentence()
    }
  end

  # ====== Follow =========
  def follow_factory do
    follower = insert(:user)
    followee = insert(:user)

    %Following.Follow{
      follower_id: follower.id,
      followee_id: followee.id
    }
  end

  # ====== Feed =========
  def post_factory do
    user = insert(:user)

    %Feed.Post{
      user_id: user.id,
      body: Faker.Lorem.sentence()
    }
  end

  # ====== ChatLog =========
  def history_factory do
    streamer = insert(:user)
    viewer = insert(:user)
    user_ids = [streamer.id, viewer.id]

    %ChatLog.History{
      user_ids: user_ids,
      messages: []
    }
  end

  def message_factory do
    user = insert(:user)

    %ChatLog.Message{
      user_id: user.id,
      body: Faker.Lorem.paragraph()
    }
  end

  # ====== Notification =========
  def new_follower_factory do
    %{
      type: :new_follower,
      from_id: Ecto.UUID.generate()
    }
  end

  def followee_is_live_factory do
    %{
      type: :followee_is_live,
      from_id: Ecto.UUID.generate()
    }
  end

  def new_message_factory do
    %{
      type: :new_message,
      from_id: Ecto.UUID.generate(),
      content: Faker.Lorem.sentence()
    }
  end

  def new_post_factory do
    %{
      type: :new_post,
      from_id: Ecto.UUID.generate(),
      content: Faker.Lorem.sentence()
    }
  end
end
