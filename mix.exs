defmodule ZaZaar.Mixfile do
  use Mix.Project

  def project do
    [
      app: :zazaar,
      version: "0.0.1",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deploy_dir: "/opt/zazaar/zazaar/",
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ZaZaar.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["test/support", "lib"]
  defp elixirc_paths(:dev), do: ["lib", "test/support/factory.ex"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # phoenix
      {:cowboy, "~> 1.0"},
      {:phoenix, "~> 1.3.2"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_pubsub, "~> 1.0"},
      {:gettext, "~> 0.11"},
      # DB
      {:postgrex, ">= 0.0.0"},
      # authentication
      {:guardian, "~> 1.0"},
      {:guardian_db, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:argon2_elixir, "~> 1.2"},
      {:ueberauth, "~> 0.4"},
      {:ueberauth_facebook, "~> 0.7"},
      # util
      {:ecto_enum, "~> 1.0"},
      {:hackney,
       github: "yuchunc/hackney", branch: "add-user-headers-only-option", override: true},
      {:httpoison, "~> 1.0"},
      {:phoenix_inline_svg, "~> 1.1"},
      # deployment
      {:distillery, "~> 2.0"},
      # dev and test
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:mix_test_watch, "~> 0.5", only: :dev, runtime: false},
      {:ex_machina, "~> 2.2", only: [:test, :dev]},
      {:faker, "~> 0.9", only: [:test, :dev]},
      {:mox, "~> 0.3", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": [
        "ecto.create",
        "ecto.migrate",
        "run priv/repo/#{Atom.to_string(Mix.env())}-seeds.exs"
      ],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      "test.api": ["test --only ot_api"]
    ]
  end
end
