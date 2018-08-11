# Usage
## Conventions
MoneyBin is designed to be a core component in a system that needs to track, transfer, and group balances in accounts. It is simply an interface to a set of `Ecto.Schema`s through several modules; it's a library of functions & structs, not it's own OTP application.

Deletion is a tricky thing to accomplish in a double entry system, given that deleting an account would cause an inconsistency in the journal entriies (total bebits vs total credits). The simplest approach is to not delete records, which is the approach MoneyBin takes. This can lead to issues since having large numbers of records isn't an approach that scales well in a system that relies heavily on aggregate values.

If an account were to have such a large number of journal entries that calculating the balance became a performance issue, the solution needs to maintain the balance of bebit and credit entries in the journal table. With this in mind, the solution would be to create a new account to replace the old account and to transfer the balance to it.

## Accounts
Accounts are the core primitive of MoneyBin, but in the database an account row holds very little data. The data in `MoneyBin.Account` structs are primarily aggregate data from the `MoneyBin.JournalEntry` collection.

### Creation
```elixir
iex> MoneyBin.Accounts.create()
%MoneyBin.Account{}
```
