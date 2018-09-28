defmodule Mix.Tasks.Docker.Build do
  use Mix.Task

  @shortdoc "Build docker image from distillery release"
  @preferred_cli_env :prod
  @moduledoc """
  Build docker image from distillery release.
  Any arguments and options will be passed directly to
  `docker build` command.
  ## Examples
      # Build your app release
      mix docker.build
      # Skip cache
      mix docker.build --no-cache
  """

  defdelegate run(args), to: MixDocker, as: :build
end

defmodule Mix.Tasks.Docker.Release do
  use Mix.Task

  @shortdoc "Build minimal, self-contained docker image"
  @preferred_cli_env :prod
  @moduledoc """
  Build minimal, self-contained docker image
  Any arguments and options will be passed directly to
  `docker build` command.
  ## Examples
      # Build minimal container
      mix docker.release
      # Skip cache
      mix docker.release --no-cache
  """
  defdelegate run(args), to: MixDocker, as: :release
end
