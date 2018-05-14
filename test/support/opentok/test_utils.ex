defmodule OpenTok.TestUtils do
  def with_config(config, function) do
    freezed_config = Application.get_env(:zazaar, OpenTok, %{})

    tmp_config =
      Application.get_env(:zazaar, OpenTok, %{})
      |> Map.new()
      |> Map.merge(config)

    Application.put_env(:zazaar, OpenTok, tmp_config)

    result = function.()

    Application.put_env(:zazaar, OpenTok, freezed_config)

    result
  end
end
