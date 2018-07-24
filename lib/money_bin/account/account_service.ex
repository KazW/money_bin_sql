defmodule MoneyBin.Accounts do
  use MoneyBin, :service

  def build(attrs \\ %{}), do: @schemas[:account].changeset(attrs)

  def create(attrs \\ %{}), do: build(attrs) |> @repo.insert! |> to_model

  def find(%_{account_id: id}), do: find(id)
  def find(%_{id: id}), do: find(id)
  def find(id), do: id |> account_query |> @repo.one |> to_model

  def account_query(id),
    do:
      from(acc in @schemas[:account])
      |> join(:left, [acc], je in subquery(journal_query(id)), acc.id == je.account_id)
      |> join(:left, [acc, _], sj in subquery(settled_journal_query(id)), acc.id == sj.account_id)
      |> select([acc, je, sj], %{
        id: type(acc.id, :binary_id),
        debit_sum: type(je.debit_sum, :decimal),
        settled_debit_sum: type(sj.debit_sum, :decimal),
        credit_sum: type(je.credit_sum, :decimal),
        settled_credit_sum: type(sj.credit_sum, :decimal),
        balance: type(je.balance, :decimal),
        settled_balance: type(sj.balance, :decimal),
        transaction_count: type(je.transaction_count, :integer),
        settled_transaction_count: type(sj.transaction_count, :integer),
        inserted_at: type(acc.inserted_at, :utc_datetime),
        updated_at: type(acc.updated_at, :utc_datetime)
      })

  defp journal_query(id),
    do:
      from(je in @schemas[:journal_entry])
      |> where([je], je.account_id == ^id)
      |> select([je], %{
        account_id: type(^id, je.account_id),
        debit_sum: coalesce(sum(je.debit_amount), 0),
        credit_sum: coalesce(sum(je.credit_amount), 0),
        balance: fragment("COALESCE(SUM(?) - SUM(?), 0)", je.debit_amount, je.credit_amount),
        transaction_count: count(je.account_id)
      })

  defp settled_journal_query(id),
    do:
      journal_query(id)
      |> where([je], not is_nil(je.settled_at) and je.settled_at <= fragment("NOW()"))

  defp to_model(%_{} = acc), do: Map.from_struct(acc) |> to_model
  defp to_model(acc) when is_map(acc), do: Account.new(acc)
  defp to_model(acc), do: acc
end
