defmodule MoneyBin.Accounts do
  use MoneyBin, :service

  def create(attrs \\ %{}), do: @schemas[:account].changeset(attrs) |> @repo.insert!

  def find(%_{account_id: id}), do: find(id)
  def find(id), do: account_query() |> where([account], account.id == ^id) |> @repo.one

  def account_query,
    do:
      from(
        account in @schemas[:account],
        left_join: entry in assoc(account, :entries),
        group_by: account.id,
        select_merge: %{
          debit_total: coalesce(sum(entry.debit_amount), 0),
          credit_total: coalesce(sum(entry.credit_amount), 0),
          balance:
            fragment(
              "? - ?",
              coalesce(sum(entry.debit_amount), 0),
              coalesce(sum(entry.credit_amount), 0)
            ),
          entry_count: count(entry.id)
        }
      )
end
