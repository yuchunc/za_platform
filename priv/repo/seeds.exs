require Logger

if Mix.env == :dev do
  import LiveAuction.Factory

  Logger.info("Adding stream")

  {:ok, ot_session} = OpenTok.request_session_id
  dev_streamer = insert(:user, email: "foo@bar.com", password: "123123", encrypted_password: Comeonin.Argon2.hashpwsalt("123123"))
  insert(:stream, ot_session_id: ot_session, streamer_id: dev_streamer.id)
end
