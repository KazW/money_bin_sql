use Mix.Config

# MoneyBin configuration
config :money_bin, :settings, repo: MoneyBin.Test.Repo

# Ecto and DB configuration.
config :money_bin, ecto_repos: [MoneyBin.Test.Repo]
config :postgrex, :json_library, Jason

config :money_bin, MoneyBin.Test.Repo,
  migration_primary_key: [id: :uuid, type: :binary_id],
  migration_timestamps: [type: :utc_datetime],
  database: "money_bin_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "priv/test/repo",
  ownership_timeout: 1_800_000
