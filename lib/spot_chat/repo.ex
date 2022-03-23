defmodule SpotChat.Repo do
  use Ecto.Repo,
    otp_app: :spot_chat,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 25
end
