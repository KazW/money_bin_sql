defmodule MoneyBin.Transactions do
  use MoneyBin, :service

  @moduledoc """
  This module is the primary interface for creating and retrieving transactions.
  """

  @doc """
  Creates a `MoneyBin.Transaction`.

  Must have at least 2 entries and total of credits must match total of debits.
  `debit_amount` and `credit_amount` cannot be set to zero.

  ## Examples

      iex> MoneyBin.Transactions.create(%{
        entries: [
          %{account_id: user_account_id, credit_amount: "5"}
          %{account_id: sales_acount_id, debit_amount: "5"}
        ]
      })
      %MoneyBin.Transaction{}

  """
  def create(attrs \\ %{}),
    do: attrs |> @schemas[:transaction].changeset |> @repo.insert |> unwrap

  @doc """
  Retrieves a `MoneyBin.Transaction`.

  ## Examples

      iex> MoneyBin.Transactions.find(transaction_id)
      %MoneyBin.Transaction{}

  """
  def find(%_{transaction_id: id}), do: find(id)
  def find(id), do: @schemas[:transaction] |> @repo.get(id) |> @repo.preload(:entries)
end
