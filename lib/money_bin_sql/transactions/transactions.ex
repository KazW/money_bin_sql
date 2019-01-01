defmodule MoneyBinSQL.Transactions do
  use MoneyBinSQL, :service

  @moduledoc """
  This module is the primary interface for creating and retrieving transactions.
  """

  @doc """
  Creates a `MoneyBinSQL.Transaction`.

  Must have at least 2 entries and total of credits must match total of debits.
  `debit_amount` and `credit_amount` cannot be set to zero.

  ## Examples

      iex> MoneyBinSQL.Transactions.create(%{
        entries: [
          %{account_id: user_account_id, credit_amount: "5"}
          %{account_id: sales_acount_id, debit_amount: "5"}
        ]
      })
      %MoneyBinSQL.Transaction{}

  """
  def create(attrs \\ %{}),
    do: attrs |> @schemas[:transaction].changeset |> @repo.insert |> unwrap

  @doc """
  Retrieves a `MoneyBinSQL.Transaction`.

  ## Examples

      iex> MoneyBinSQL.Transactions.find(transaction_id)
      %MoneyBinSQL.Transaction{}

  """
  def find(%_{transaction_id: id}), do: find(id)
  def find(id), do: @schemas[:transaction] |> @repo.get(id) |> @repo.preload(:entries)
end
