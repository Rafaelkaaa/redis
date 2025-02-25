defmodule Elasticsearch.Repo do
  use Ecto.Repo,
    otp_app: :elasticsearch,
    adapter: Ecto.Adapters.Postgres
end
