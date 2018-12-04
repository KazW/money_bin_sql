import Ecto.Query
alias MoneyBin.Test.Repo

alias MoneyBin.{
  Account,
  Accounts,
  JournalEntry,
  Ledger,
  Ledgers,
  LedgerMember,
  Transaction,
  Transactions
}

:ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo, ownership_timeout: 180_000_000)
require IEx
IEx.pry()
