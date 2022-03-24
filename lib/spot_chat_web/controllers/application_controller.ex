defmodule SpotChatWeb.ApplicationController do
  use SpotChatWeb, :controller

  def not_found(conn, _params) do
    conn
    |> put_status(:not_found)
    |> render(SpotChatWeb.ApplicationView, "not_found.json")
  end
end
