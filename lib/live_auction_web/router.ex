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

  scope "/", LiveAuctionWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/s", LiveStreamController, only: [:show]

    resources "/m", MembershipController, singleton: true, only: [:show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveAuctionWeb do
  #   pipe_through :api
  # end
end
