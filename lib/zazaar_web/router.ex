defmodule ZaZaarWeb.Router do
  use ZaZaarWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(
      Guardian.Plug.Pipeline,
      module: ZaZaar.Auth.Guardian,
      error_handler: ZaZaar.Auth.ErrorHandler
    )

    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(Guardian.Plug.LoadResource)
  end

  scope "/", ZaZaarWeb do
    pipe_through([:browser, :auth])

    resources "/m", MembershipController, singleton: true, only: [:show] do
      resources("/streaming", StreamingController, singleton: true, only: [:show])
    end
  end

  scope "/", ZaZaarWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", LiveStreamController, :index)

    resources("/auth", SessionController, singleton: true, only: [:show, :create, :delete])

    resources("/s", LiveStreamController, only: [:show])
  end
end
