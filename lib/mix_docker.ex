defmodule MixDocker do
  require Logger

  @dockerfile_path    :code.priv_dir(:mix_docker)
  @dockerfile_build   Application.get_env(:mix_docker, :dockerfile_build, "Dockerfile.build")
  @dockerfile_release Application.get_env(:mix_docker, :dockerfile_release, "Dockerfile.release")

  def build(args) do
    with_dockerfile @dockerfile_build, fn ->
      docker :build, @dockerfile_build, image(:build), args
    end

    Mix.shell.info "Docker image #{image(:build)} has been successfully created"
  end

  def release(args) do
    app     = app_name()
    version = app_version() || release_version()

    cid = "mix_docker-#{:rand.uniform(1000000)}"

    with_dockerfile @dockerfile_release, fn ->
      docker :rm, cid
      docker :create, cid, image(:build)
      docker :cp, cid, "/opt/app/_build/prod/rel/#{app}/releases/#{version}/#{app}.tar.gz", "#{app}.tar.gz"
      docker :rm, cid
      docker :build, @dockerfile_release, image(:release), args
    end

    Mix.shell.info "Docker image #{image(:release)} has been successfully created"
    Mix.shell.info "You can now test your app with the following command:"
    Mix.shell.info "  docker run -it --rm #{image(:release)} foreground"
  end

  defp image(tag) do
    image_name() <> ":" <> to_string(tag)
  end

  defp image_name do
    Application.get_env(:mix_docker, :image) || to_string(app_name())
  end


  defp docker(:cp, cid, source, dest) do
    system! "docker", ["cp", "#{cid}:#{source}", dest]
  end

  defp docker(:build, dockerfile, tag, args) do
    system! "docker", ["build", "-f", dockerfile, "-t", tag] ++ args ++ ["."]
  end

  defp docker(:create, name, image) do
    system! "docker", ["create", "--name", name, image]
  end

    defp docker(:rm, cid) do
    system "docker", ["rm", "-f", cid]
  end

  defp with_dockerfile(name, fun) do
    if File.exists?(name) do
      fun.()
    else
      try do
        copy_dockerfile(name)
        fun.()
      after
        File.rm(name)
      end
    end
  end
    defp copy_dockerfile(name) do
    app = app_name()
    content = [@dockerfile_path, name]
      |> Path.join
      |> File.read!
      |> String.replace("${APP}", to_string(app))
    File.write!(name, content)
  end

    defp system(cmd, args) do
    Logger.debug "$ #{cmd} #{args |> Enum.join(" ")}"
    System.cmd(cmd, args, into: IO.stream(:stdio, :line))
  end

  defp system!(cmd, args) do
    {_, 0} = system(cmd, args)
  end


    defp app_name do
    release_name_from_cwd = File.cwd! |> Path.basename |> String.replace("-", "_")
    Mix.Project.get.project[:app] || release_name_from_cwd
  end

    defp app_version do
    Mix.Project.get.project[:version]
  end

    defp release_version do
    {:ok, rel} = Mix.Releases.Release.get(:default)
    rel.version
  end
end
