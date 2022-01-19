defmodule SpotChatWeb.Plugs.Auth do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    url = "http://localhost:3000/accounts"
    token = get_token(conn)
    headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json; Charset=utf-8"]
    response = HTTPoison.get!(url, headers)
    req = Poison.decode!(response.body)
    assign(conn, :current_user, req)
  end

  def get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end

end
