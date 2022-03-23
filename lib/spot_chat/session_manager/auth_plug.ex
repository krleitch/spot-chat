defmodule SpotChat.SessionManager.AuthPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> get_token()
    |> verify_token()
    |> case do
      {:ok, user} -> assign(conn, :current_user, user)
      _unauthorized -> assign(conn, :current_user, nil)
    end
  end

  def authenticate_api_user(conn, _opts) do
    if Map.get(conn.assigns, :current_user) do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(SpotChatWeb.ErrorView)
      |> render(:"401")
      |> halt()
    end
  end

  def verify_token(token) do
    url = "http://localhost:3000/chat/user"
    headers = [Authorization: "Bearer #{token}", Accept: "Application/json; Charset=utf-8"]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        user = Poison.decode!(body)
        {:ok, user["user"]}

      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, :resource_not_found}

      {:error, %HTTPoison.Error{reason: _reason}} ->
        {:error, :resource_not_found}
    end
  end

  def get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["bearer " <> token] -> token
      _ -> nil
    end
  end
end
