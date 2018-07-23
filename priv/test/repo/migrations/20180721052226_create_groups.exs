defmodule MoneyBin.Test.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      timestamps()
    end

    create table(:account_group_links) do
      add(:account_id, references(:accounts), null: false)
      add(:group_id, references(:groups), null: false)
      add(:credit, :boolean, null: false, default: false)
      add(:name, :string, null: false)

      timestamps()
    end

    create(unique_index(:account_group_links, [:group_id, :name]))
  end
end
