defmodule LiveAuction.Auth.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :live_auction

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
