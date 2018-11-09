ExUnit.start()

# starts ex_machina
{:ok, _} = Application.ensure_all_started(:ex_machina)

Ecto.Adapters.SQL.Sandbox.mode(ZaZaar.Repo, :manual)

ExUnit.configure(exclude: [:ot_api, :fb_api])

Mox.defmock(OpenTok.ApiMock, for: OpenTok.Behaviour)

Mox.defmock(Facebook.GraphApiMock, for: Facebook.ApiBehaviour)
