defmodule MoneyBin.Ledgers do
  use MoneyBin, :service

  def create(attrs \\ %{}), do: @schemas[:ledger].changeset(attrs) |> @repo.insert! |> to_model

  def find(%_{ledger_id: id}), do: find(id)
  def find(id), do: id |> ledger_query |> @repo.one |> to_model

  def ledger_query(id),
    do:
      from(led in @schemas[:ledger])
      |> join(:left, [led], jr in subquery(journal_query(id)), led.id == jr.ledger_id)
      |> select([led, jr], %{
        id: type(led.id, :binary_id),
        debit_sum: type(jr.debit_sum, :decimal),
        credit_sum: type(jr.credit_sum, :decimal),
        balance: type(fragment("? - ?", jr.debit_sum, jr.credit_sum), :decimal),
        transaction_count: type(jr.transaction_count, :integer),
        inserted_at: type(led.inserted_at, :utc_datetime),
        updated_at: type(led.updated_at, :utc_datetime)
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

  defp to_model(led) when is_map(led), do: Ledger.new(led)
end
