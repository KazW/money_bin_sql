import Ecto.Query
alias MoneyBinSQL.Test.Repo

alias MoneyBinSQL.{
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
