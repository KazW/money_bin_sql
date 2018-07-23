defmodule MoneyBin.Test.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add(:reversal_for_transaction_id, references(:transactions))
      add(:settled_at, :utc_datetime, default: fragment("now()"))
      add(:debit_amount, :decimal, scale: 8, precision: 16, null: false)
      add(:credit_amount, :decimal, scale: 8, precision: 16, null: false)

      timestamps()
    end

    create(unique_index(:transactions, :reversal_for_transaction_id))
  end
end
