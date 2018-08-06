defmodule MoneyBin.Test.Repo.Migrations.CreateCharts do
  use Ecto.Migration

  def change do
    create table(:charts) do
      timestamps()
    end

    create table(:ledger_chart_links) do
      add(:ledger_id, references(:ledgers), null: false)
      add(:chart_id, references(:charts), null: false)
      add(:credit, :boolean, null: false, default: false)
      add(:name, :string, null: false)

      timestamps()
    end

    create(unique_index(:ledger_chart_links, [:chart_id, :name]))
  end
end
