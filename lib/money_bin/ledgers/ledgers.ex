defmodule MoneyBin.Ledgers do
  use MoneyBin, :service

  def create(attrs \\ %{}), do: @schemas[:ledger].changeset(attrs) |> @repo.insert! |> find()

  def find(%_{ledger_id: id}), do: find(id)
  def find(id), do: ledger_query() |> where([ledger], ledger.id == ^id) |> @repo.one

  def ledger_query,
    do:
      from(ledger in @schemas[:ledger])
      |> join(:left, [ledger], members in assoc(ledger, :members))
      |> join(:left, [_, mem], acc in assoc(mem, :account))
      |> join(
        :left,
        [_, mem],
        debacc in ^@schemas[:account],
        mem.account_id == debacc.id and mem.credit == false
      )
      |> join(
        :left,
        [_, _, _, debacc],
        debent in ^@schemas[:journal_entry],
        debent.account_id == debacc.id
      )
      |> join(
        :left,
        [_, mem],
        credacc in ^@schemas[:account],
        mem.account_id == credacc.id and mem.credit == true
      )
      |> join(
        :left,
        [_, _, _, _, _, credacc],
        credent in ^@schemas[:journal_entry],
        credent.account_id == credacc.id
      )
      |> group_by([ledger], ledger.id)
      |> select_merge([_, _, acc, _, debent, _, credent], %{
        value:
          fragment(
            "? + ?",
            fragment(
              "? - ?",
              coalesce(sum(debent.debit_amount), 0),
              coalesce(sum(debent.credit_amount), 0)
            ),
            fragment(
              "? - ?",
              coalesce(sum(credent.credit_amount), 0),
              coalesce(sum(credent.debit_amount), 0)
            )
          ),
        entry_count:
          fragment(
            "? + ?",
            count(fragment("DISTINCT ?", debent.id)),
            count(fragment("DISTINCT ?", credent.id))
          ),
        account_count: count(fragment("DISTINCT ?", acc.id))
      })
end
