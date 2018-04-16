ExUnit.start()

# starts ex_machina
{:ok, _} = Application.ensure_all_started(:ex_machina)

Ecto.Adapters.SQL.Sandbox.mode(LiveAuction.Repo, :manual)

Mox.defmock(OpenTok.ApiMock, for: OpenTok.Behaviour)
