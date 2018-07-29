defmodule MoneyBin.LedgersTest do
  use MoneyBin.DataCase

  alias MoneyBin.Ledgers
  alias MoneyBin.Ledger

  describe "ledgers" do
    def ledger_fixture(attrs \\ %{}) do
      attrs
      |> Enum.into(%{})
      |> Ledgers.create()
    end

    test "build should be return a valid changeset" do
      changeset = Ledgers.build()

      assert changeset.valid? == true
    end

    test "create should create an ledger" do
      ledger = Ledgers.create()
      found_ledger = Ledgers.find(ledger.id)

      assert %Ledger{} = ledger
      assert %Ledger{} = found_ledger
    end

    test "debit_sum should be 0 for a new ledger" do
      ledger = ledger_fixture()
      found_ledger = Ledgers.find(ledger.id)

      assert D.equal?(0, ledger.debit_sum)
      assert D.equal?(0, found_ledger.debit_sum)
    end

    test "credit_sum should be 0 for a new ledger" do
      ledger = ledger_fixture()
      found_ledger = Ledgers.find(ledger.id)

      assert D.equal?(0, ledger.credit_sum)
      assert D.equal?(0, found_ledger.credit_sum)
    end

    test "balance should be 0 for a new ledger" do
      ledger = ledger_fixture()
      found_ledger = Ledgers.find(ledger.id)

      assert D.equal?(0, ledger.balance)
      assert D.equal?(0, found_ledger.balance)
    end

    test "transaction_count should be 0 for a new ledger" do
      ledger = ledger_fixture()
      found_ledger = Ledgers.find(ledger.id)

      assert D.equal?(0, ledger.transaction_count)
      assert D.equal?(0, found_ledger.transaction_count)
    end
  end
end
