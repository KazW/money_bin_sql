defmodule MoneyBin.Accounts do
  use MoneyBin, :service

  def create(attrs \\ %{}), do: @schemas[:account].changeset(attrs) |> @repo.insert!

  def find(%_{account_id: id}), do: find(id)
  def find(id), do: id |> account_query |> @repo.one

  def account_query(id),
    do:
      from(
        account in @schemas[:account],
        left_join: entry in assoc(account, :entries),
        group_by: account.id,
        where: account.id == ^id,
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
