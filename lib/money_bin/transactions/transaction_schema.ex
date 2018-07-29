defmodule MoneyBin.Schemas.Transaction do
  use MoneyBin, :schema

  schema @tables[:transaction] do
    belongs_to(
      :reversed_transaction,
      @schemas[:transaction],
      foreign_key: :reversal_for_transaction_id
    )

    field(:settled_at, :utc_datetime)
    field(:debit_amount, :decimal)
    field(:credit_amount, :decimal)

    timestamps()
  end

  @fields [:reversal_for_transaction_id, :settled_at, :debit_amount, :credit_amount]

  @doc false
  def changeset(transaction \\ %__MODULE__{}, attrs) do
    transaction
    |> cast(attrs, @fields)
    |> cast_assoc(:reversed_transaction)
    |> assoc_constraint(:reversed_transaction)
  end
end
