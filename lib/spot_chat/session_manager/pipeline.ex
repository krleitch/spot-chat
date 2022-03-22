defmodule SpotChat.SessionManager.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :spot_chat,
    error_handler: SpotChat.SessionManager.ErrorHandler,
    module: SpotChat.SessionManager.Guardian

  # plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
