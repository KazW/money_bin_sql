defmodule MoneyBinSQL.Ledger do
  use MoneyBinSQL, :schema
  @moduledoc false

  schema @tables[:ledger] do
    has_many(:members, @schemas[:ledger_member])
    has_many(:accounts, through: [:members, :account])
    has_many(:entries, through: [:accounts, :entries])
    has_many(:transactions, through: [:entries, :transaction])

    field(:value, :decimal, virtual: true, default: 0)
    field(:account_count, :integer, virtual: true, default: 0)
    field(:entry_count, :integer, virtual: true, default: 0)

    timestamps()
  end

  def changeset(record \\ %__MODULE__{}, attrs),
    do:
      record
      |> cast(attrs, [])
      |> cast_assoc(:members, required: true)
      |> validate_length(:members, min: 2)
end
