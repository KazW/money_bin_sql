defmodule MoneyBin.Ledgers do
  use MoneyBin, :service

  def build(attrs \\ %{}), do: @schemas[:ledger].changeset(attrs)

  def create(attrs \\ %{}), do: build(attrs) |> @repo.insert! |> to_model

  def find(%_{ledger_id: id}), do: find(id)
  def find(%_{id: id}), do: find(id)
  def find(id), do: id |> ledger_query |> @repo.one |> to_model

  def ledger_query(id),
    do:
      from(acc in @schemas[:ledger])
      |> join(:left, [acc], je in subquery(journal_query(id)), acc.id == je.ledger_id)
      |> join(
        :left,
        [acc, _],
        sje in subquery(settled_journal_query(id)),
        acc.id == sje.ledger_id
      )
      |> select([acc, je, sje], %{
        id: type(acc.id, :binary_id),
        debit_sum: type(je.debit_sum, :decimal),
        settled_debit_sum: type(sje.debit_sum, :decimal),
        credit_sum: type(je.credit_sum, :decimal),
        settled_credit_sum: type(sje.credit_sum, :decimal),
        balance: type(fragment("? - ?", je.debit_sum, je.credit_sum), :decimal),
        settled_balance: type(fragment("? - ?", sje.debit_sum, sje.credit_sum), :decimal),
        transaction_count: type(je.transaction_count, :integer),
        settled_transaction_count: type(sje.transaction_count, :integer),
        inserted_at: type(acc.inserted_at, :utc_datetime),
        updated_at: type(acc.updated_at, :utc_datetime)
      })

  defp journal_query(id),
    do:
      from(je in @schemas[:journal_entry])
      |> where([je], je.ledger_id == ^id)
      |> select([je], %{
        ledger_id: type(^id, je.ledger_id),
        debit_sum: coalesce(sum(je.debit_amount), 0),
        credit_sum: coalesce(sum(je.credit_amount), 0),
        transaction_count: count(je.transaction_id)
      })

  defp settled_journal_query(id),
    do:
      journal_query(id)
      |> where([je], not is_nil(je.settled_at) and je.settled_at <= fragment("NOW()"))

  defp to_model(%_{} = acc), do: Map.from_struct(acc) |> to_model
  defp to_model(acc) when is_map(acc), do: Ledger.new(acc)
  defp to_model(acc), do: acc
end
