defmodule SpotChatWeb.UserSocket do
  use Phoenix.Socket
  use HTTPoison.Base

  channel "chat_room:*", SpotChatWeb.ChatRoomChannel
  channel "chat_friend:*", SpotChatWeb.ChatFriendChannel

  # A Socket handler
  #
  # It's possible to control the websocket connection and
  # assign values that can be accessed by your channel topics.

  ## Channels
  # Uncomment the following line to define a "room:*" topic
  # pointing to the `SpotChatWeb.RoomChannel`:
  #
  # channel "room:*", SpotChatWeb.RoomChannel
  #
  # To create a channel file, use the mix task:
  #
  #     mix phx.gen.channel Room
  #
  # See the [`Channels guide`](https://hexdocs.pm/phoenix/channels.html)
  # for further details.


  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    # get the user from server with the jwt
    url = "http://localhost:3000/chat/user"
    headers = ["Authorization": "Bearer #{token}", "Accept": "Application/json; Charset=utf-8"]
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response = Poison.decode!(body)
        user = for {key, val} <- response["user"], into: %{}, do: {String.to_atom(key), val}
        {:ok, assign(assign(socket, :current_user, user), :token, token)}
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        :error
      {:error, %HTTPoison.Error{reason: _reason}} ->
        :error
    end
  end

  @impl true
  def connect(_params, _socket), do: :error

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.SpotChatWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(socket), do: "users_socket:#{socket.assigns.current_user.userId}"
end
