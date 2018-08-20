# Usage
## Conventions
MoneyBin is designed to be a core component in a system that needs to track, transfer, and group balances in accounts. It is simply an interface to a set of `Ecto.Schema`s through several modules; it's a library of functions & structs, not it's own OTP application.

Deletion is a tricky thing to accomplish in a double entry system, given that deleting an account would cause an inconsistency in the journal entriies (total bebits vs total credits). The simplest approach is to not delete records, which is the approach MoneyBin takes. This can lead to issues since having large numbers of records isn't an approach that scales well in a system that relies heavily on aggregate values.

If an account were to have such a large number of journal entries that calculating the balance became a performance issue, the solution needs to maintain the balance of bebit and credit entries in the journal table. With this in mind, the solution would be to create a new account to replace the old account and to transfer the balance to it.

## Accounts
Accounts are the core primitive of MoneyBin, but in the database an account row holds very little data. The data in `MoneyBin.Account` structs are primarily aggregate data from the `MoneyBin.JournalEntry` collection. The metadata field is the only field that can be set during creation or updated. 

### Creation
```elixir
iex> MoneyBin.Accounts.create(metadata: %{})
%MoneyBin.Account{}
```

### Updating
```elixir
iex> MoneyBin.Accounts.update(metadata: %{})
%MoneyBin.Account{}
```

## Journal Entries
Journal entries hold the most important information in MoneyBin. They capture the amount of the transfer and wether it represents a debit or credit. There is no way to directly interact with journal entries. Journal entries are created through transactions, transactions ensure the debit and credit amounts line up (equal zero). Instead, the `MoneyBin.JournalEntries` module provides methods to verify the integrity of the entries and some general statistics about them.

### Trial balance
The trial balance simply sums the amount of credit and debit entries and
ensures that they equal zero. This will return a tuple with an atom as
the first element (`:ok` or `:error`), the second element will either be
true or be an atom representing which column has a greater sum
(`true`, `:credit_amount`, or `:debit_amount`).
If `MoneyBin.JournalEntries.trial_balance!/0` if called it will raise
an error if the trial balance is not zero.
```elixir
iex> MoneyBin.JournalEntries.trial_balance()
true
```