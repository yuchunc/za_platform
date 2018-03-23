defmodule LiveAuctionWeb.Router do
  use LiveAuctionWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    LiveAuction.Auth.AuthPipeline
  end

  scope "/", LiveAuctionWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/auth", SessionController, only: [:create, :delete]
  end

  scope "/api", LiveAuctionWeb do
    pipe_through [:browser, :auth]

    resources "/s", LiveStreamController, only: [:show]
    resources "/m", MembershipController, singleton: true, only: [:show]
  end
end
