defmodule MoneyBin.Test.Repo.Migrations.CreateJournalEntries do
  use Ecto.Migration

  def change do
    create table(:journal_entries) do
      add(:transaction_id, references(:transactions), null: false)
      add(:account_id, references(:accounts), null: false)

      add(:debit_amount, :decimal, scale: 8, precision: 16)
      add(:credit_amount, :decimal, scale: 8, precision: 16)

      timestamps()
    end

    create(unique_index(:journal_entries, [:transaction_id, :account_id]))
  end
end
