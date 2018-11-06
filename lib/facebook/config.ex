defmodule Facebook.Config do
  @fb_creds Application.get_env(:ueberauth, Ueberauth.Strategy.Facebook.OAuth)

  def graph_url, do: "https://graph.facebook.com"

  def access_token, do: Keyword.fetch!(@fb_creds, :client_access_token)
end
