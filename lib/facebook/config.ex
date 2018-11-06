defmodule Facebook.Config do
  @fb_creds Application.get_env(:ueberauth, Ueberauth.Strategy.Facebook.OAuth)

  def graph_url, do: "https://graph.facebook.com"

  def api_id, do: Keyword.fetch!(@fb_creds, :client_id)

  def api_key, do: Keyword.fetch!(@fb_creds, :client_key)
end
