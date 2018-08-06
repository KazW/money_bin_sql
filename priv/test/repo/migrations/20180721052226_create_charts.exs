defmodule MoneyBin.Test.Repo.Migrations.CreateLedgers do
  use Ecto.Migration

  def change do
    create table(:ledgers) do
      timestamps()
    end

    create table(:account_ledger_links) do
      add(:account_id, references(:accounts), null: false)
      add(:ledger_id, references(:ledgers), null: false)
      add(:credit, :boolean, null: false, default: false)
      add(:name, :string, null: false)

      timestamps()
    end

    create(unique_index(:account_ledger_links, [:ledger_id, :name]))
  end
end
