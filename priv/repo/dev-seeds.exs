require Logger

import ZaZaar.Factory

Logger.info("Start dev seeds")

{:ok, ot_session} = OpenTok.request_session_id

streamer = insert(:streamer, email: "streamer@foo.bar", password: "123123", encrypted_password: Comeonin.Argon2.hashpwsalt("123123"))
insert(:channel, ot_session_id: ot_session, streamer_id: streamer.id)

insert(:user, email: "viewer@foo.bar", password: "123123", encrypted_password: Comeonin.Argon2.hashpwsalt("123123"))

Logger.info("End dev seeds")
