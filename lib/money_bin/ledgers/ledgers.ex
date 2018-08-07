defmodule MoneyBin.Ledgers do
  use MoneyBin, :service

  def create(attrs \\ %{}), do: @schemas[:ledger].changeset(attrs) |> @repo.insert! |> find()

  def find(%_{ledger_id: id}), do: find(id)
  def find(id), do: ledger_query() |> where([ledger], ledger.id == ^id) |> @repo.one

  def ledger_query,
    do:
      from(ledger in @schemas[:ledger])
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

  defp ledger_joins(query),
    do:
      query
      |> join(:left, [ledger], members in assoc(ledger, :members))
      |> join(:left, [_, mem], acc in assoc(mem, :account))
      |> join(
        :left,
        [_, mem],
        da in ^@schemas[:account],
        mem.account_id == da.id and mem.credit == false
      )
      |> join(
        :left,
        [_, _, _, da],
        de in ^@schemas[:journal_entry],
        de.account_id == da.id
      )
      |> join(
        :left,
        [_, mem],
        ca in ^@schemas[:account],
        mem.account_id == ca.id and mem.credit == true
      )
      |> join(
        :left,
        [_, _, _, _, _, ca],
        ce in ^@schemas[:journal_entry],
        ce.account_id == ca.id
      )
end
