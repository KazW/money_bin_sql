defmodule MoneyBin.JournalEntry do
  use MoneyBin, :model

  embedded_schema do
    field(:id, :binary_id)

    field(:ledger_id, :binary_id)
    field(:transaction_id, :binary_id)
    field(:debit_amount, :decimal)
    field(:credit_amount, :decimal)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def new(record \\ %__MODULE__{}, attrs),
    do: record |> cast(attrs, __schema__(:fields)) |> apply_changes
end
