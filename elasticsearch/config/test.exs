import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :elasticsearch, Elasticsearch.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "elasticsearch_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elasticsearch, ElasticsearchWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "j+DFt0taaNLXhQ0wEvg0VIXENijac0x9+Kdg7IMRkmLk0XfEptdjdKWUjqd6rHai",
  server: false

# In test we don't send emails
config :elasticsearch, Elasticsearch.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

config :elasticsearch,
  url: "http://localhost:9200",
  index: "posts"

config :elastix,
  json_options: [keys: :atoms!],
  httpoison_options: [hackney: [pool: :elastix_pool]]
