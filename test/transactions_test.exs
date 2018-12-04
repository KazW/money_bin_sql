defmodule MoneyBin.TransactionsTest do
  use MoneyBin.DataCase

  alias MoneyBin.Accounts
  alias MoneyBin.JournalEntry
  alias MoneyBin.Transaction
  alias MoneyBin.Transactions

  describe "transactions" do
    def fixture_set(amount \\ "1.5") do
      account_a = Accounts.create()
      account_b = Accounts.create()

      %{
        account_a: account_a,
        account_b: account_b,
        transaction:
          Transactions.create(%{
            entries: [
              %{account_id: account_a.id, debit_amount: D.new(amount)},
              %{account_id: account_b.id, credit_amount: D.new(amount)}
            ]
          })
      }
    end

    def account_entry_count(id) do
      query = from(je in JournalEntry)

      query
      |> where([je], je.account_id == ^id)
      |> select([je], count(je.id))
      |> Repo.one()
    end

    def transaction_entry_count(id) do
      query = from(je in JournalEntry)

      query
      |> where([je], je.transaction_id == ^id)
      |> select([je], count(je.id))
      |> Repo.one()
    end

    def journal_entry_for(tra_id, led_id) do
      query = from(je in JournalEntry)

      query
      |> where([je], je.transaction_id == ^tra_id)
      |> where([je], je.account_id == ^led_id)
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
      account_a = set[:account_a]
      account_b = set[:account_b]
      entry_a = journal_entry_for(transaction.id, account_a.id)
      entry_b = journal_entry_for(transaction.id, account_b.id)

      assert account_entry_count(account_a.id) == 1
      assert account_entry_count(account_b.id) == 1
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
      account_a = Accounts.create()
      account_b = Accounts.create()

      transaction =
        Transactions.create(%{
          entries: [
            %{account_id: account_a.id, debit_amount: D.new("1.2")},
            %{account_id: account_b.id, credit_amount: D.new("1.5")}
          ]
        })

      refute transaction.valid?
      assert "debit total must equal credit total" in errors_on(transaction).entries
    end

    test "should not allow an account to be used twice" do
      account_a = Accounts.create()

      transaction =
        Transactions.create(%{
          entries: [
            %{account_id: account_a.id, debit_amount: D.new("1.2")},
            %{account_id: account_a.id, credit_amount: D.new("1.2")}
          ]
        })

      refute transaction.valid?
      assert %{account_id: ["has already been taken"]} in errors_on(transaction).entries
    end

    test "should support complex transactions" do
      # payment provider
      provider_led = Accounts.create()
      # fees collected by payment provider
      provider_fee_led = Accounts.create()
      # User's account
      user_led = Accounts.create()
      # Fees paid for user
      user_fee_led = Accounts.create()

      transaction =
        Transactions.create(%{
          entries: [
            %{account_id: provider_led.id, credit_amount: D.new("9.41")},
            %{account_id: user_led.id, debit_amount: D.new("9.41")},
            %{account_id: provider_fee_led.id, debit_amount: D.new("0.59")},
            %{account_id: user_fee_led.id, credit_amount: D.new("0.59")}
          ]
        })

      assert %MoneyBin.Transaction{} = transaction
      assert length(transaction.entries) == 4
    end
  end
end
