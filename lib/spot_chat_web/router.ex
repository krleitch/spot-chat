defmodule SpotChatWeb.Router do
  use SpotChatWeb, :router

  pipeline :api do
    plug :accepts, ["json"]

    # authenticate
    plug Guardian.Plug.Pipeline, module: SpotChat.Guardian, error_handler: SpotChat.AuthErrorHandler
    plug Guardian.Plug.VerifyHeader, scheme: 'Bearer'
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  scope "/api", SpotChatWeb do
    pipe_through :api

    # Sessions
    post "/sessions", SessionController, :create
    post "/sessions/refresh", SessionController, :refresh

    # Rooms
    resources "/rooms", RoomController, only: [:index, :create]
    post "/rooms/:id/join", RoomController, :join
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: SpotChatWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
