defmodule MoneyBin.Test.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add(:reversal_for_transaction_id, references(:transactions))
      add(:settled_at, :utc_datetime, default: fragment("now()"))

      timestamps()
    end

    create(unique_index(:transactions, :reversal_for_transaction_id))
  end
end
