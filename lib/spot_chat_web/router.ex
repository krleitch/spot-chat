defmodule SpotChatWeb.Router do
  use SpotChatWeb, :router

  # Use Guardian Auth or Token Auth
  pipeline :auth do
    plug SpotChat.SessionManager.AuthPlug
  end

  pipeline :guardian_auth do
    plug SpotChat.SessionManager.Pipeline
  end

  pipeline :guardian_ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # No Auth, Use with guardian
  # scope "/api", SpotChatWeb do
  # pipe_through [:api]
  # Sessions
  # post "/sessions", SessionController, :create
  # post "/sessions/refresh", SessionController, :refresh
  # end

  # Definitely logged in scope
  scope "/api", SpotChatWeb do
    # pipe_through [:api, :guardian_auth, :guardian_ensure_auth]
    pipe_through [:api, :auth, :authenticate_api_user]

    # Rooms
    resources "/rooms", RoomController, only: [:index, :create, :update] do
      resources "/messages", MessageController, only: [:index]
    end

    post "/rooms/:id/join", RoomController, :join
    get "/rooms/user", RoomController, :rooms
  end

  scope "/", SpotChatWeb do
    get "/*path", ApplicationController, :not_found
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through [:fetch_session, :protect_from_forgery]

  #     live_dashboard "/dashboard", metrics: SpotChatWeb.Telemetry
  #   end
  # end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  # if Mix.env() == :dev do
  #   scope "/dev" do
  #     pipe_through [:fetch_session, :protect_from_forgery]

  #     forward "/mailbox", Plug.Swoosh.MailboxPreview
  #   end
  # end
end
