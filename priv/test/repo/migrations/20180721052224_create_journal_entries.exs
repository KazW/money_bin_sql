defmodule MoneyBin.Test.Repo.Migrations.CreateJournalEntries do
  use Ecto.Migration

  def change do
    create table(:journal_entries) do
      add(:transaction_id, references(:transactions), null: false)
      add(:ledger_id, references(:ledgers), null: false)

      add(:settled_at, :utc_datetime, default: fragment("now()"))
      add(:debit_amount, :decimal, scale: 8, precision: 16, null: false)
      add(:credit_amount, :decimal, scale: 8, precision: 16, null: false)

      timestamps()
    end

    create(unique_index(:journal_entries, [:transaction_id, :ledger_id]))
  end
end
