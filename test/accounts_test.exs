defmodule MoneyBin.AccountsTest do
  use MoneyBin.DataCase

  alias MoneyBin.Accounts
  alias MoneyBin.Account

  describe "accounts" do
    def account_fixture(attrs \\ %{}), do: Accounts.create(attrs)

    test "create should create a account" do
      account = Accounts.create()
      found_account = Accounts.find(account.id)

      assert %Account{} = account
      assert %Account{} = found_account
      assert account.id == found_account.id
    end

    test "debit_sum should be 0 for a new account" do
      account = account_fixture()
      found_account = Accounts.find(account.id)

      assert D.equal?(0, account.debit_sum)
      assert D.equal?(0, found_account.debit_sum)
    end

    test "credit_sum should be 0 for a new account" do
      account = account_fixture()
      found_account = Accounts.find(account.id)

      assert D.equal?(0, account.credit_sum)
      assert D.equal?(0, found_account.credit_sum)
    end

    test "balance should be 0 for a new account" do
      account = account_fixture()
      found_account = Accounts.find(account.id)

      assert D.equal?(0, account.balance)
      assert D.equal?(0, found_account.balance)
    end

    test "transaction_count should be 0 for a new account" do
      account = account_fixture()
      found_account = Accounts.find(account.id)

      assert D.equal?(0, account.transaction_count)
      assert D.equal?(0, found_account.transaction_count)
    end
  end
end
