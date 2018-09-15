defmodule ZaZaarWeb.Router do
  use ZaZaarWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)

    plug(
      Guardian.Plug.Pipeline,
      module: ZaZaar.Auth.Guardian,
      error_handler: ZaZaar.Auth.ErrorHandler
    )

    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Guardian.Plug.EnsureAuthenticated)
  end

  scope "/", ZaZaarWeb do
    pipe_through(:browser)

    get("/", LiveStreamController, :index)

    # resources("/auth", SessionController, singleton: true, only: [:show, :create, :delete])

    resources("/s", LiveStreamController, only: [:show])
  end

  scope "/auth", ZaZaarWeb do
    pipe_through(:browser)

    get("/:provider", SessionController, :request)
    get("/:provider/callback", SessionController, :callback)
  end

  scope "/m", ZaZaarWeb do
    pipe_through([:browser, :auth])

    delete("/logout", SessionController, :delete)

    resources "/", MembershipController, singleton: true, only: [:show] do
      resources("/streaming", StreamingController, singleton: true, only: [:show])
    end
  end
end
