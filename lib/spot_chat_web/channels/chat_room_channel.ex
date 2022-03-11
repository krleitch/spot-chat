defmodule SpotChatWeb.ChatRoomChannel do
  use SpotChatWeb, :channel

  @impl true
  def join("chat_room:lobby", payload, socket) do
    # IO.puts "TESTING ID " <> socket.assigns.current_user["id"]
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # private rooms
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  @impl true
  def handle_info(:after_join, socket) do
    message = %{
      "content" => "User joined chat",
      "timestamp" => DateTime.utc_now(),
      "type" => "INFO",
      "profilePicture" => -1,
      "profilePictureSrc" => "op.png",
      "owned" => true
    }

    push(socket, "new_message", message)
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat_room:lobby).
  @impl true
  def handle_in("new_message", payload, socket) do
    message = %{
      "content" => payload["content"],
      "timestamp" => DateTime.utc_now(),
      "type" => "MESSAGE",
      "profilePicture" => -1,
      "profilePictureSrc" => "op.png",
      "owned" => true
    }

    broadcast(socket, "new_message", message)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
