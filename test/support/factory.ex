defmodule LiveAuction.Factory do
  use ExMachina.Ecto, repo: LiveAuction.Repo

  alias LiveAuction.{Account, Streaming}

  def streamer_factory do
    build(:user, tier: :streamer)
  end

  def viewer_factory do
    build(:user, tier: :viewer)
  end

  def stream_factory do
    %Streaming.Stream{
      ot_session_id: sequence("some_ot_session_id"),
      streamer_id: insert(:streamer) |> Map.get(:id)
    }
  end

  def user_factory do
    %Account.User{
      username: sequence(Faker.Internet.user_name),
      phone: Faker.Phone.EnUs.phone,
      email: Faker.Internet.email
    }
  end

end
