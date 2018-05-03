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
    plug Guardian.Plug.Pipeline, module: LiveAuction.Auth.Guardian, error_handler: LiveAuction.Auth.ErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  scope "/", LiveAuctionWeb do
    pipe_through [:browser, :auth]

    resources "/m", MembershipController, singleton: true, only: [:show] do
      resources "/streaming", StreamingController, singleton: true, only: [:show]
    end
  end

  scope "/", LiveAuctionWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/auth", SessionController, singleton: true, only: [:show, :create, :delete]

    resources "/s", LiveStreamController, only: [:index, :show]
  end
end
