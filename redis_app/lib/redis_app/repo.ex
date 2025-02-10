defmodule RedisApp.Repo do
  use Ecto.Repo,
    otp_app: :redis_app,
    adapter: Ecto.Adapters.Postgres
end
