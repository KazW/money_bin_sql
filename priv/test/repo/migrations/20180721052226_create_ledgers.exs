defmodule MoneyBin.Test.Repo.Migrations.CreateLedgers do
  use Ecto.Migration

  def change do
    create table(:ledgers) do
      timestamps()
    end

    create table(:ledger_members) do
      add(:account_id, references(:accounts), null: false)
      add(:ledger_id, references(:ledgers), null: false)
      add(:credit, :boolean, null: false, default: false)

      timestamps()
    end

    create(unique_index(:ledger_members, [:ledger_id, :account_id]))
  end
end
