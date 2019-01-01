# MoneyBinSQL

Flexible double entry based accounting for Elixir.

## Installation

Add MoneyBinSQL to your deps:

```elixir
{:money_bin_sql, "~> 0.0.3"}
```

Configure which repo MoneyBinSQL should use:

```elixir
# MoneyBinSQL configuration
config :money_bin_sql, :settings, repo: MyApp.Repo
```

Generate a migration:

```shell
mix ecto.gen.migration create_money_bin_sql
```

Modify it to be similar to this:

```elixir
defmodule MyApp.Repo.Migrations.CreateMoneyBinSQL do
  use Ecto.Migration

  def change do
    MoneyBinSQL.Migrations.change()
  end
end
```

## Configuration

The `repo` setting is required, the `table` setting is optional.

```elixir
# MoneyBinSQL configuration
config :money_bin_sql, :settings,
  repo: MyApp.Repo,
  tables: [
    account: "accounts",
    transaction: "transactions",
    journal_entry: "journal_entries",
    ledger: "ledgers",
    ledger_member: "ledger_members"
  ]
```
