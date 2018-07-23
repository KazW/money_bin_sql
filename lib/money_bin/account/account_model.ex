defmodule MoneyBin.Account do
  use MoneyBin, :model

  embedded_schema do
    field(:id, :binary_id)

    field(:debit_sum, :decimal, default: 0)
    field(:settled_debit_sum, :decimal, default: 0)

    field(:credit_sum, :decimal, default: 0)
    field(:settled_credit_sum, :decimal, default: 0)

    field(:balance, :decimal, default: 0)
    field(:settled_balance, :decimal, default: 0)

    field(:transaction_count, :integer, default: 0)
    field(:settled_transaction_count, :integer, default: 0)

    timestamps(type: :utc_datetime)
  end
end
