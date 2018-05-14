require Logger

if Mix.env == :dev do
  import ZaZaar.Factory

  Logger.info("Adding stream")

  {:ok, ot_session} = OpenTok.request_session_id
  streamer = insert(:user, email: "streamer@foo.bar", password: "123123", encrypted_password: Comeonin.Argon2.hashpwsalt("123123"))
  insert(:stream, ot_session_id: ot_session, streamer_id: streamer.id)

  insert(:user, email: "viewer@foo.bar", password: "123123", encrypted_password: Comeonin.Argon2.hashpwsalt("123123"))
end
