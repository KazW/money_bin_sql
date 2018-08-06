defmodule MoneyBin.Transactions do
  use MoneyBin, :service

  def create(attrs \\ %{}), do: @schemas[:transaction].changeset(attrs) |> @repo.insert |> unwrap
  def find(%_{transaction_id: id}), do: find(id)
  def find(id), do: @schemas[:transaction] |> @repo.get(id) |> @repo.preload(:entries)
end
