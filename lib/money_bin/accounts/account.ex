defmodule MoneyBin.Account do
  use MoneyBin, :schema
  @moduledoc false

  schema @tables[:account] do
    has_many(:entries, @schemas[:journal_entry])
    has_many(:transactions, through: [:entries, :transactions])
    has_many(:memberships, @schemas[:ledger_member])
    has_many(:ledgers, through: [:memberships, :ledger])

    field(:balance, :decimal, virtual: true, default: 0)
    field(:debit_total, :decimal, virtual: true, default: 0)
    field(:credit_total, :decimal, virtual: true, default: 0)
    field(:entry_count, :integer, virtual: true, default: 0)

    timestamps()
  end

  def changeset(record \\ %__MODULE__{}, attrs), do: record |> cast(attrs, [])
end
