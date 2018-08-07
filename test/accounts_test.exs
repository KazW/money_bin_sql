defmodule MoneyBin.AccountsTest do
  use MoneyBin.DataCase

  alias MoneyBin.Account
  alias MoneyBin.Accounts

  describe "accounts" do
    def account_fixture(attrs \\ %{}), do: Accounts.create(attrs)

    test "create should create a account" do
      account = Accounts.create()
      found_account = Accounts.find(account.id)

      assert %Account{} = account
      assert %Account{} = found_account
      assert account.id == found_account.id
    end

    test "debit_total should be 0 for a new account" do
      account = account_fixture()
      found_account = Accounts.find(account.id)

      assert D.equal?(0, account.debit_total)
      assert D.equal?(0, found_account.debit_total)
    end

    test "credit_total should be 0 for a new account" do
      account = account_fixture()
      found_account = Accounts.find(account.id)

      assert D.equal?(0, account.credit_total)
      assert D.equal?(0, found_account.credit_total)
    end

    test "balance should be 0 for a new account" do
      account = account_fixture()
      found_account = Accounts.find(account.id)

      assert D.equal?(0, account.balance)
      assert D.equal?(0, found_account.balance)
    end

    test "entry_count should be 0 for a new account" do
      account = account_fixture()
      found_account = Accounts.find(account.id)

      assert D.equal?(0, account.entry_count)
      assert D.equal?(0, found_account.entry_count)
    end
  end
end
