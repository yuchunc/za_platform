# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LiveAuction.Repo.insert!(%LiveAuction.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

if Mix.env == :dev do
  import LiveAuction.Factory

  {:ok, ot_session} = OpenTok.create_session

  insert(:stream, ot_session_id: ot_session)
end
