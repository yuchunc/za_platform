defmodule OpenTok.TestUtils do
  def with_config(config, function) do
    freezed_config = Application.get_env(:live_auction, OpenTok, %{})

    tmp_config =
      Application.get_env(:live_auction, OpenTok, %{})
      |> Map.new()
      |> Map.merge(config)

    Application.put_env(:live_auction, OpenTok, tmp_config)

    result = function.()

    Application.put_env(:live_auction, OpenTok, freezed_config)

    result
  end
end
