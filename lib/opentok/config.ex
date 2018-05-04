defmodule OpenTok.Config do
  @moduledoc """
  OpenTok Config module
  """

  @default_config %{
    env: Mix.env(),
    endpoint: "https://api.opentok.com"
  }

  def initialize do
    app_config =
      Application.get_env(:live_auction, OpenTok, %{})
      |> Map.new()

    config =
      @default_config
      |> Map.merge(app_config)

    Application.put_env(:live_auction, OpenTok, config)

    if config[:key] && config[:secret] do
      :ok
    else
      {:error, :invalid_config}
    end
  end
end
