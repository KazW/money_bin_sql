defmodule MoneyBin.Ledgers do
  use MoneyBin, :service

  def create(attrs \\ %{}), do: @schemas[:ledger].changeset(attrs) |> @repo.insert!

  def find(%_{ledger_id: id}), do: find(id)
  def find(id), do: id |> ledger_query |> @repo.one

  def ledger_query(id),
    do:
      from(
        ledger in @schemas[:ledger],
        left_join: entry in assoc(ledger, :entries),
        group_by: ledger.id,
        where: ledger.id == ^id,
        select_merge: %{
          debit_sum: coalesce(sum(entry.debit_amount), 0),
          credit_sum: coalesce(sum(entry.credit_amount), 0),
          balance:
            fragment(
              "? - ?",
              coalesce(sum(entry.debit_amount), 0),
              coalesce(sum(entry.credit_amount), 0)
            ),
          transaction_count: count(entry.transaction_id)
        }
      )
end
