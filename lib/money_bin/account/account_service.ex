defmodule MoneyBin.Accounts do
  use MoneyBin, :service

  def build(attrs \\ %{}), do: @schemas[:account].changeset(attrs)

  def create(attrs \\ %{}), do: build(attrs) |> @repo.insert! |> to_model

  def find(%_{account_id: id}), do: find(id)
  def find(%_{id: id}), do: find(id)

  def find(id) do
    id
    |> account_query
    |> @repo.one
    |> to_model
  end

  def account_query(id),
    do:
      from(acc in @schemas[:account])
      |> join(:inner, [acc], je in subquery(journal_query(id)), je.id == acc.id)
      |> join(:inner, [acc, _], sj in subquery(settled_journal_query(id)), sj.id == acc.id)
      |> select(
        [acc, je, sj],
        %{
          id: acc.id,
          debit_sum: je.debit_sum,
          settled_debit_sum: sj.debit_sum,
          credit_sum: je.credit_sum,
          settled_credit_sum: sj.credit_sum,
          balance: je.balance,
          settled_balance: sj.balance,
          transaction_count: je.transaction_count,
          settled_transaction_count: sj.transaction_count,
          inserted_at: acc.inserted_at,
          updated_at: acc.updated_at
        }
      )

  def journal_query(id),
    do:
      from(
        je in @schemas[:journal_entry],
        select: %{
          id: type(^id, je.account_id),
          debit_sum: sum(je.debit_amount),
          credit_sum: sum(je.credit_amount),
          balance: fragment("SUM(?) - SUM(?)", je.debit_amount, je.credit_amount),
          transaction_count: count(je.account_id)
        },
        where: je.account_id == ^id
      )

  def settled_journal_query(id),
    do:
      from(
        je in journal_query(id),
        where: not(is_nil(je.settled_at)) and je.settled_at <= fragment("NOW()")
      )

  defp to_model(%_{} = acc), do: Map.from_struct(acc) |> to_model

  defp to_model(acc) when is_map(acc) do
    acc
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.into(%{})
    |> (&struct(Account, &1)).()
  end
end
