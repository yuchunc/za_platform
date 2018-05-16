defmodule ZaZaar.Factory do
  use ExMachina.Ecto, repo: ZaZaar.Repo

  alias ZaZaar.{Account, Streaming}

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

  def channel_factory do
    %Streaming.Channel{
      ot_session_id: sequence("some_ot_session_id"),
      streamer_id: insert(:streamer) |> Map.get(:id)
    }
  end

  def stream_factory do
    %Streaming.Stream{}
  end

  def comment_factory do
    user = insert(:user)

    %Streaming.Comment{
      user_id: user.id,
      content: Faker.Lorem.sentence()
    }
  end
end
