use Mix.Config

# MoneyBinSQL configuration
config :money_bin_sql, :settings, repo: MoneyBinSQL.Test.Repo

# Ecto and DB configuration.
config :money_bin_sql, ecto_repos: [MoneyBinSQL.Test.Repo]
config :postgrex, :json_library, Jason

config :money_bin_sql, MoneyBinSQL.Test.Repo,
  migration_primary_key: [id: :uuid, type: :binary_id],
  database: "money_bin_sql_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "priv/test/repo"
