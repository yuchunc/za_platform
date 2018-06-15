defmodule ZaZaar.Factory do
  use ExMachina.Ecto, repo: ZaZaar.Repo

  alias ZaZaar.{Account, Streaming, Following, Feed, ChatLog}

  # ====== Account =========
  def streamer_factory do
    build(:user, tier: :streamer)
  end

  def viewer_factory do
    build(:user, tier: :viewer)
  end

  def user_factory do
    password = "12345678"

    %Account.User{
      username: sequence(Faker.Internet.user_name()),
      phone: Faker.Phone.EnUs.phone(),
      email: Faker.Internet.email(),
      password: password,
      encrypted_password: Comeonin.Argon2.hashpwsalt(password)
    }
  end

  # ====== Streaming =========

  def channel_factory do
    streamer = insert(:streamer)

    %Streaming.Channel{
      ot_session_id: sequence("some_ot_session_id"),
      streamer_id: streamer.id
    }
  end

  def stream_factory do
    %Streaming.Stream{
      channel: build(:channel)
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
    follower = insert(:viewer)
    followee = insert(:streamer)

    %Following.Follow{
      follower_id: follower.id,
      followee_id: followee.id
    }
  end

  # ====== Feed =========
  def post_factory do
    user = insert(:viewer)

    %Feed.Post{
      user_id: user.id,
      body: Faker.Lorem.sentence()
    }
  end

  # ====== ChatLog =========
  def history_factory do
    streamer = insert(:streamer)
    viewer = insert(:viewer)
    user_ids = [streamer.id, viewer.id]

    %ChatLog.History{
      user_ids: user_ids,
      messages: [build(:note, user_id: Enum.random(user_ids))]
    }
  end

  def note_factory do
    user = insert(:viewer)

    %ChatLog.Message{
      user_id: user.id,
      body: Faker.Lorem.paragraph()
    }
  end
end
