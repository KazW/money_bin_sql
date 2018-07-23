defmodule MoneyBin.Schemas.JournalEntry do
  use MoneyBin, :schema

  schema @tables[:journal_entry] do
    belongs_to(:transaction, @schemas[:transaction])
    belongs_to(:account, @schemas[:account])

    field(:settled_at, :utc_datetime)
    field(:debit_amount, :decimal)
    field(:credit_amount, :decimal)

    timestamps()
  end

  @fields [:transaction_id, :account_id, :settled_at, :debit_amount, :credit_amount]
  @required_fields [:transaction_id, :account_id]

  @doc false
  def changeset(link \\ %__MODULE__{}, attrs) do
    link
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> constrained_assoc_cast(:transaction)
    |> constrained_assoc_cast(:account)
    |> unique_constraint(:account_id, name: :journal_entries_transaction_id_account_id_index)
  end
end
