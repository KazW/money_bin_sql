defmodule MoneyBin.TransactionsTest do
  use MoneyBin.DataCase

  alias MoneyBin.Ledgers
  alias MoneyBin.Transactions
  alias MoneyBin.Transaction
  alias MoneyBin.Schemas

  describe "transactions" do
    def fixture_set(amount \\ "1.5") do
      ledger_a = Ledgers.create()
      ledger_b = Ledgers.create()

      %{
        ledger_a: ledger_a,
        ledger_b: ledger_b,
        transaction:
          Transactions.create(%{
            entries: [
              %{ledger_id: ledger_a.id, debit_amount: D.new(amount)},
              %{ledger_id: ledger_b.id, credit_amount: D.new(amount)}
            ]
          })
      }
    end

    def ledger_entry_count(id) do
      from(je in Schemas.JournalEntry)
      |> where([je], je.ledger_id == ^id)
      |> select([je], count(je.id))
      |> Repo.one()
    end

    def transaction_entry_count(id) do
      from(je in Schemas.JournalEntry)
      |> where([je], je.transaction_id == ^id)
      |> select([je], count(je.id))
      |> Repo.one()
    end

    def journal_entry_for(tra_id, led_id) do
      from(je in Schemas.JournalEntry)
      |> where([je], je.transaction_id == ^tra_id)
      |> where([je], je.ledger_id == ^led_id)
      |> Repo.one()
    end

    test "should create and find a transaction" do
      transaction = fixture_set()[:transaction]
      found_transaction = Transactions.find(transaction.id)

      assert %Transaction{} = transaction
      assert %Transaction{} = found_transaction
      assert transaction.id == found_transaction.id
    end

    test "creates associated records for a basic transaction" do
      amount = D.new("1.5")
      set = fixture_set(amount)

      transaction = set[:transaction]
      ledger_a = set[:ledger_a]
      ledger_b = set[:ledger_b]
      entry_a = journal_entry_for(transaction.id, ledger_a.id)
      entry_b = journal_entry_for(transaction.id, ledger_b.id)

      assert ledger_entry_count(ledger_a.id) == 1
      assert ledger_entry_count(ledger_b.id) == 1
      assert D.equal?(entry_a.debit_amount, amount)
      assert D.equal?(entry_b.credit_amount, amount)
      assert transaction_entry_count(set[:transaction].id) == 2
    end

    test "should not accept negative values" do
      amount = D.new("-1.5")
      %Ecto.Changeset{} = transaction = fixture_set(amount)[:transaction]

      refute transaction.valid?
      assert %{debit_amount: ["must be greater than 0"]} in errors_on(transaction).entries
      assert %{credit_amount: ["must be greater than 0"]} in errors_on(transaction).entries
    end

    test "should require debit amount to match credit amount" do
      ledger_a = Ledgers.create()
      ledger_b = Ledgers.create()

      transaction =
        Transactions.create(%{
          entries: [
            %{ledger_id: ledger_a.id, debit_amount: D.new("1.2")},
            %{ledger_id: ledger_b.id, credit_amount: D.new("1.5")}
          ]
        })

      refute transaction.valid?
      assert "debit total must equal credit total" in errors_on(transaction).entries
    end

    test "should not allow an account to be used twice" do
      ledger_a = Ledgers.create()

      transaction =
        Transactions.create(%{
          entries: [
            %{ledger_id: ledger_a.id, debit_amount: D.new("1.2")},
            %{ledger_id: ledger_a.id, credit_amount: D.new("1.2")}
          ]
        })

      refute transaction.valid?
      assert %{ledger_id: ["has already been taken"]} in errors_on(transaction).entries
    end

    test "should support complex transactions" do
      # payment provider
      provider_led = Ledgers.create()
      # fees collected by payment provider
      provider_fee_led = Ledgers.create()
      # User's ledger
      user_led = Ledgers.create()
      # Fees paid for user
      user_fee_led = Ledgers.create()

      transaction =
        Transactions.create(%{
          entries: [
            %{ledger_id: provider_led.id, credit_amount: D.new("9.41")},
            %{ledger_id: user_led.id, debit_amount: D.new("9.41")},
            %{ledger_id: provider_fee_led.id, debit_amount: D.new("0.59")},
            %{ledger_id: user_fee_led.id, credit_amount: D.new("0.59")}
          ]
        })

      assert %MoneyBin.Transaction{} = transaction
      assert length(transaction.entries) == 4
    end
  end
end
