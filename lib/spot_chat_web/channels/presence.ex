defmodule SpotChatWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](https://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence,
    otp_app: :spot_chat,
    pubsub_server: SpotChat.PubSub

  # def fetch(_topic, entries) do
  # %{
  # "users" => %{"count" => count_presences(entries, "users")}
  # }
  # end

  # defp count_presences(entries, key) do
  # case get_in(entries, [key, :metas]) do
  # nil -> 0
  # metas -> length(metas)
  # end
  # end
end
