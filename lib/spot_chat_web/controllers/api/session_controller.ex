defmodule SpotChatWeb.SessionController do
  use SpotChatWeb, :controller

  alias SpotChat.{SessionManager.Guardian}

  def create(conn, %{"token" => token} = params) do
    case authenticate(params) do
      {:ok, _user} ->
        new_conn = Guardian.Plug.sign_in(conn, token)
        jwt = Guardian.Plug.current_token(new_conn)

        new_conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt)

      :error ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json")
    end
  end

  def refresh(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)

    case Guardian.refresh(jwt) do
      {:ok, new_jwt, _new_claims} ->
        conn
        |> put_status(:ok)
        |> render("show.json", jwt: new_jwt)

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("forbidden.json", error: "Not authenticated")
    end
  end

  def authenticate(%{"token" => token}) do
    url = "http://localhost:3000/chat/user"
    headers = [Authorization: "Bearer #{token}", Accept: "Application/json; Charset=utf-8"]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        user = Poison.decode!(body)
        {:ok, user["user"]}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        :error

      {:error, %HTTPoison.Error{reason: _reason}} ->
        :error
    end
  end
end
