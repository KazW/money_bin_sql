defmodule MoneyBin.Account do
  use MoneyBin, :schema

  schema @tables[:account] do
    has_many(:entries, @schemas[:journal_entry])

    field(:balance, :decimal, virtual: true, default: 0)
    field(:debit_total, :decimal, virtual: true, default: 0)
    field(:credit_total, :decimal, virtual: true, default: 0)
    field(:entry_count, :integer, virtual: true, default: 0)

    timestamps()
  end

  @doc false
  def changeset(record \\ %__MODULE__{}, attrs), do: record |> cast(attrs, [])
end
