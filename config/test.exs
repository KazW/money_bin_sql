use Mix.Config

# MoneyBin configuration
config :money_bin, MoneyBin,
  repo: MoneyBin.Test.Repo,
  schemas: [
    account: MoneyBin.Schemas.Account,
    transaction: MoneyBin.Schemas.Transaction,
    journal_entry: MoneyBin.Schemas.JournalEntry,
    group: MoneyBin.Schemas.Group,
    group_link: MoneyBin.Schemas.GroupLink
  ],
  tables: [
    account: "accounts",
    transaction: "transactions",
    journal_entry: "journal_entries",
    group: "groups",
    group_link: "account_group_links"
  ]

# Ecto configuration.
config :money_bin, ecto_repos: [MoneyBin.Test.Repo]

config :money_bin, MoneyBin.Test.Repo,
  migration_primary_key: [id: :uuid, type: :binary_id],
  migration_timestamps: [type: :utc_datetime],
  adapter: Ecto.Adapters.Postgres,
  database: "money_bin_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "priv/test/repo",
  ownership_timeout: 1_800_000
