defmodule MoneyBin.Transactions do
  use MoneyBin, :service

  def create(attrs \\ %{}),
    do: @schemas[:transaction].changeset(attrs) |> @repo.insert |> to_model

  def find(%_{transaction_id: id}), do: find(id)

  def find(id),
    do: @repo.get(@schemas[:transaction], id) |> @repo.preload(:entries) |> to_model

  defp to_model({:ok, tra}), do: to_model(tra)
  defp to_model({:error, error}), do: error
  defp to_model(tra) when is_map(tra), do: Transaction.new(tra)
end
