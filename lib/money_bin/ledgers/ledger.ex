defmodule MoneyBin.Ledger do
  use MoneyBin, :schema

  schema @tables[:ledger] do
    has_many(:entries, @schemas[:journal_entry])

    field(:balance, :decimal, virtual: true, default: 0)
    field(:debit_sum, :decimal, virtual: true, default: 0)
    field(:credit_sum, :decimal, virtual: true, default: 0)
    field(:transaction_count, :integer, virtual: true, default: 0)

    timestamps()
  end

  @doc false
  def changeset(record \\ %__MODULE__{}, attrs), do: record |> cast(attrs, [])
end
