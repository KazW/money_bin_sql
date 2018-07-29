defmodule MoneyBin.Schemas.JournalEntry do
  use MoneyBin, :schema

  schema @tables[:journal_entry] do
    belongs_to(:transaction, @schemas[:transaction])
    belongs_to(:ledger, @schemas[:ledger])

    field(:settled_at, :utc_datetime)
    field(:debit_amount, :decimal)
    field(:credit_amount, :decimal)

    timestamps()
  end

  @fields [:transaction_id, :ledger_id, :settled_at, :debit_amount, :credit_amount]
  @required_fields [:transaction_id, :ledger_id]

  @doc false
  def changeset(link \\ %__MODULE__{}, attrs) do
    link
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> constrained_assoc_cast(:transaction)
    |> constrained_assoc_cast(:ledger)
    |> unique_constraint(:ledger_id, name: :journal_entries_transaction_id_ledger_id_index)
  end
end
