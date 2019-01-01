defmodule MoneyBinSQL.LedgersTest do
  use MoneyBinSQL.DataCase

  alias MoneyBinSQL.Accounts
  alias MoneyBinSQL.Ledger
  alias MoneyBinSQL.Ledgers
  alias MoneyBinSQL.Transactions

  describe "transactions" do
    def account_set do
      %{
        provider_acc: Accounts.create(),
        provider_fees: Accounts.create(),
        user_cash: Accounts.create(),
        user_fees: Accounts.create()
      }
    end

    def ledger_set(accs) do
      %{
        provider:
          Ledgers.create(%{
            members: [
              %{account_id: accs.provider_acc.id, credit: true},
              %{account_id: accs.provider_fees.id, credit: false}
            ]
          }),
        user:
          Ledgers.create(%{
            members: [
              %{account_id: accs.user_cash.id, credit: false},
              %{account_id: accs.user_fees.id, credit: true}
            ]
          })
      }
    end

    def calulate_fee(x) do
      fee = x |> D.mult("0.029") |> D.add("0.3")
      %{amount: D.sub(x, fee), fee: fee, total: x}
    end

    def create_transaction(accs, %{amount: amount, fee: fee}) do
      Transactions.create(%{
        entries: [
          %{account_id: accs.provider_acc.id, credit_amount: amount},
          %{account_id: accs.provider_fees.id, debit_amount: fee},
          %{account_id: accs.user_cash.id, debit_amount: amount},
          %{account_id: accs.user_fees.id, credit_amount: fee}
        ]
      })
    end

    def run_trials(trials, accs) do
      trials |> Enum.map(&Map.put(&1, :transaction, create_transaction(accs, &1)))
    end

    def ledger_test(trial_count, accs, total, ledger) do
      assert map_size(accs) / 2 == ledger.account_count
      assert map_size(accs) / 2 * trial_count == ledger.entry_count
      assert D.equal?(total, ledger.value)
    end

    test "create" do
      accs = account_set()
      leds = ledger_set(accs)

      assert %Ledger{} = leds.provider
      assert %Ledger{} = leds.user
    end

    test "should work for 100 random transactions" do
      trial_count = 100
      accs = account_set()
      leds = ledger_set(accs)
      rands = for _ <- 1..trial_count, do: :rand.uniform(10_000_000)
      total = rands |> Enum.reduce(&D.add/2)
      trials = rands |> Enum.map(&calulate_fee/1)

      run_trials(trials, accs)
      final_provider_ledger = Ledgers.find(leds.provider.id)
      final_user_ledger = Ledgers.find(leds.user.id)

      [final_provider_ledger, final_user_ledger]
      |> Enum.each(&ledger_test(trial_count, accs, total, &1))
    end
  end
end
