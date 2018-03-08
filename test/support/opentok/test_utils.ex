defmodule OpenTok.TestUtils do

  def with_config(config, function) do
    freezed_config = Application.get_env(:opentok, :config, %{})

    tmp_config =
      Application.get_env(:opentok, :config, %{})
      |> Map.merge(config)
    Application.put_env(:opentok, :config, tmp_config)

    result = function.()

    Application.put_env(:opentok, :config, freezed_config)

    result
  end
end
