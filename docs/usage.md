# Usage

## Conventions

MoneyBin is designed to be a core component in a system that needs to track,
transfer, and group balances in accounts. It is a pure library: simply a set
of structs, behaviours, and modules, not it's own OTP application.

Deletion does not exist in a double entry system, given that deleting an
account would cause an inconsistency in the journal entriies of accounts it
had transacted with.

## Accounts

Accounts are the core primitive of MoneyBin, the data they are comprised of is
mostly aggregate totals of journal entries. The metadata field is the only
field of an account that can be set during creation and later updated, it is a
map.

### Creation

```elixir
iex> MoneyBin.create_account(metadata)
%MoneyBin.Account{}
```

### Retrival

```elixir
iex> MoneyBin.get_account(account_id)
%MoneyBin.Account{}

iex> MoneyBin.get_account(bad_account_id)
{:error, %{error: :account_not_found, message: "account not found"}}
```

### Modification

```elixir
iex> MoneyBin.update_account(%MoneyBin.Account{metadata: new_metadata})
{:ok, %MoneyBin.Account{}}
```
