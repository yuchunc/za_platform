defmodule ZaZaarWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ZaZaarWeb, :controller
      use ZaZaarWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ZaZaarWeb
      import Plug.Conn
      import ZaZaarWeb.Gettext

      ZaZaarWeb.context_schema_aliases()

      def current_resource(conn), do: Guardian.Plug.current_resource(conn)

      alias ZaZaarWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/zazaar_web/templates",
        namespace: ZaZaarWeb

      use PhoenixInlineSvg.Helpers, otp_app: :phoenix_inline_svg

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import ZaZaarWeb.ErrorHelpers
      import ZaZaarWeb.Gettext
      import PhoenixInlineSvg.Helpers

      alias ZaZaarWeb.Router.Helpers, as: Routes

      def current_token(conn), do: Guardian.Plug.current_token(conn)
      def current_resource(conn), do: Guardian.Plug.current_resource(conn)
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ZaZaarWeb.Gettext
      import Phoenix.View

      alias ZaZaarWeb.ErrorView

      ZaZaarWeb.context_schema_aliases()

      def current_resource(socket), do: Guardian.Phoenix.Socket.current_resource(socket)
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  @doc """
  This alias most used schemas
  NOTE use only for pattern matching!!
  """
  defmacro context_schema_aliases do
    quote do
      alias ZaZaarWeb.FallbackController
      alias ZaZaar.Auth.Guardian

      alias ZaZaar.Account
      alias Account.User

      alias ZaZaar.Streaming
      alias Streaming.{Stream, Comment}

      alias ZaZaar.Feed
      alias Feed.Post

      alias ZaZaar.ChatLog
      alias ChatLog.{History, Message}

      alias ZaZaar.Following

      alias ZaZaar.Notification
      alias Notification.{Check, Notice}
    end
  end
end
