# MoneyBinSQL [![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT) [![Build Status](https://travis-ci.com/KazW/money_bin_sql.svg?token=CRsKZKYLbnQZUawkaRLB&branch=master)](https://travis-ci.com/KazW/money_bin_sql) [![Ebert](https://ebertapp.io/github/KazW/money_bin_sql.svg)](https://ebertapp.io/github/KazW/money_bin_sql) [![Inline docs](https://inch-ci.org/github/KazW/money_bin_sql.svg)](https://inch-ci.org/github/KazW/money_bin_sql)

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

## Usage

Read on [GitHub](USAGE.md) or [Hex](usage.html).

## Documentation

[Hex Docs](https://hexdocs.pm/money_bin_sql)

## License

Copyright © 2018 Kaz Walker & Contributors

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the 'Software'), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to
do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
