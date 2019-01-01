# Usage

## Conventions

MoneyBinSQL is designed to be a core component in a system that needs to track,
transfer, and group balances in accounts. It is a pure library: simply a set
of structs, behaviours, and modules, not it's own OTP application.

Deletion does not exist in a double entry system, given that deleting an
account would cause an inconsistency in the journal entriies of accounts it
had transacted with.

## Accounts

Accounts are the core primitive of MoneyBinSQL, the data they are comprised of is
mostly aggregate totals of journal entries. The metadata field is the only
field of an account that can be set during creation and later updated, it is a
map.

### Creation

```elixir
iex> MoneyBinSQL.create_account(metadata)
%MoneyBinSQL.Account{}
```

### Retrival

```elixir
iex> MoneyBinSQL.get_account(account_id)
%MoneyBinSQL.Account{}

iex> MoneyBinSQL.get_account(bad_account_id)
{:error, %{error: :account_not_found, message: "account not found"}}
```

### Modification

```elixir
iex> MoneyBinSQL.update_account(%MoneyBinSQL.Account{metadata: new_metadata})
{:ok, %MoneyBinSQL.Account{}}
```
