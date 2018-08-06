defmodule MoneyBin.Test.Repo.Migrations.CreateLedgers do
  use Ecto.Migration

  def change do
    create table(:ledgers) do
      timestamps()
    end
  end
end
