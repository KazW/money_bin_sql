defmodule MoneyBin.Ledgers do
  use MoneyBin, :service

  @moduledoc """
  This module is the primary interface for creating and retrieving ledgers.
  It also contains a query that can be used for preloading ecto associations
  with aggregate data.
  """

  @doc """
  Creates a `MoneyBin.Ledger`.

  Must have at least 1 member accounts.
  `credit` is set to false by default, representing an asset account that
  increases in value when the account is debited. When `credit` is true,
  the account increases in value when it is credited.

  ## Examples

      iex> MoneyBin.Ledgers.create(%{
        members: [
          %{account_id: provider_acc_id, credit: true},
          %{account_id: provider_fees_id, credit: false}
        ]
      })
      %MoneyBin.Ledger{}

  """
  def create(attrs \\ %{}), do: attrs |> @schemas[:ledger].changeset |> @repo.insert! |> find()

  @doc """
  Retrieves a `MoneyBin.Ledger` with the aggregate data included, uses `ledger_query/0`.

  ## Examples

      iex> MoneyBin.Ledgers.find(ledger_id)
      %MoneyBin.Ledger{}

  """
  def find(%_{ledger_id: id}), do: find(id)
  def find(id), do: ledger_query() |> where([ledger], ledger.id == ^id) |> @repo.one

  @doc """
  An `Ecto.Query` to retrieve the aggregate information for a ledger.

  ## Examples

      iex> MoneyBin.Ledgers.ledger_query()
      %Ecto.Query{}

  """
  def ledger_query do
    query = from(ledger in @schemas[:ledger])

    query
    |> ledger_joins
    |> group_by([ledger], ledger.id)
    |> select_merge([_, _, acc, _, de, _, ce], %{
      value:
        fragment(
          "? + ?",
          fragment(
            "? - ?",
            coalesce(sum(de.debit_amount), 0),
            coalesce(sum(de.credit_amount), 0)
          ),
          fragment(
            "? - ?",
            coalesce(sum(ce.credit_amount), 0),
            coalesce(sum(ce.debit_amount), 0)
          )
        ),
      entry_count:
        fragment(
          "? + ?",
          count(fragment("DISTINCT ?", de.id)),
          count(fragment("DISTINCT ?", ce.id))
        ),
      account_count: count(fragment("DISTINCT ?", acc.id))
    })
  end

  defp ledger_joins(query),
    do:
      query
      |> join(:left, [ledger], onmembers in assoc(ledger, :members))
      |> join(:left, [_, mem], acc in assoc(mem, :account))
      |> join(
        :left,
        [_, mem],
        da in ^@schemas[:account],
        on: mem.account_id == da.id and mem.credit == false
      )
      |> join(
        :left,
        [_, _, _, da],
        de in ^@schemas[:journal_entry],
        on: de.account_id == da.id
      )
      |> join(
        :left,
        [_, mem],
        ca in ^@schemas[:account],
        on: mem.account_id == ca.id and mem.credit == true
      )
      |> join(
        :left,
        [_, _, _, _, _, ca],
        ce in ^@schemas[:journal_entry],
        on: ce.account_id == ca.id
      )
end
