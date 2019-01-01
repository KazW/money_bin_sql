# MoneyBin

Flexible double entry based accounting for Elixir.

## Installation

Add MoneyBin to your deps:

```elixir
{:money_bin, "~> 0.0.3"}
```

Configure which repo MoneyBin should use:

```elixir
# MoneyBin configuration
config :money_bin, :settings, repo: MyApp.Repo
```

Generate a migration:

```shell
mix ecto.gen.migration create_money_bin
```

Modify it to be similar to this:

```elixir
defmodule MyApp.Repo.Migrations.CreateMoneyBin do
  use Ecto.Migration

  def change do
    MoneyBin.Migrations.change()
  end
end
```

## Configuration

The `repo` setting is required, the `table` setting is optional.

```elixir
# MoneyBin configuration
config :money_bin, :settings,
  repo: MyApp.Repo,
  tables: [
    account: "accounts",
    transaction: "transactions",
    journal_entry: "journal_entries",
    ledger: "ledgers",
    ledger_member: "ledger_members"
  ]
```
