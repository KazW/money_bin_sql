defmodule MoneyBinSQL.Migrations do
  use MoneyBinSQL, :config_variables
  use Ecto.Migration
  @moduledoc false

  def change do
    create table(@tables[:account]) do
      timestamps()
    end

    create table(@tables[:transaction]) do
      add(:reversal_for_transaction_id, references(@tables[:transaction]))
      add(:amount, :decimal, scale: 8, precision: 16, null: false)

      timestamps()
    end

    create(unique_index(@tables[:transaction], :reversal_for_transaction_id))

    create table(@tables[:journal_entry]) do
      add(:transaction_id, references(@tables[:transaction]), null: false)
      add(:account_id, references(@tables[:account]), null: false)

      add(:debit_amount, :decimal, scale: 8, precision: 16)
      add(:credit_amount, :decimal, scale: 8, precision: 16)

      timestamps()
    end

    create(unique_index(@tables[:journal_entry], [:transaction_id, :account_id]))

    create table(@tables[:ledger]) do
      timestamps()
    end

    create table(@tables[:ledger_member]) do
      add(:account_id, references(@tables[:account]), null: false)
      add(:ledger_id, references(@tables[:ledger]), null: false)
      add(:credit, :boolean, null: false, default: false)

      timestamps()
    end

    create(unique_index(@tables[:ledger_member], [:ledger_id, :account_id]))
  end
end
