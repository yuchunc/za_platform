defmodule ZaZaarWeb.StreamPresence do
  use Phoenix.Presence, otp_app: :zazaar, pubsub_server: ZaZaar.PubSub
end
