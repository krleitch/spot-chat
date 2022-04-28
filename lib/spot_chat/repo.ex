defmodule SpotChat.Repo do
  use Ecto.Repo,
    otp_app: :spot_chat,
    adapter: Ecto.Adapters.Postgres

  use Paginator,
    limit: 25,
    include_total_count: true,
    total_count_primary_key_field: :id
end
