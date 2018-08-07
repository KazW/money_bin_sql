defmodule MoneyBin.Transaction do
  use MoneyBin, :schema

  schema @tables[:transaction] do
    has_many(:entries, @schemas[:journal_entry])
    has_many(:accounts, through: [:entries, :account])
    has_many(:memberships, through: [:accounts, :memberships])
    has_many(:ledgers, through: [:memberships, :ledger])

    belongs_to(
      :reversed_transaction,
      @schemas[:transaction],
      foreign_key: :reversal_for_transaction_id
    )

    field(:amount, :decimal)

    timestamps()
  end

  @fields [:reversal_for_transaction_id]

  @doc false
  def changeset(transaction \\ %__MODULE__{}, attrs) do
    transaction
    |> cast(attrs, @fields)
    |> constrained_assoc_cast(:reversed_transaction)
    |> unique_constraint(:reversal_for_transaction_id)
    |> cast_assoc(:entries, required: true)
    |> validate_length(:entries, min: 2)
    |> balance_and_set_amount
  end

  defp balance_and_set_amount(%{valid?: false} = changeset), do: changeset

  defp balance_and_set_amount(%{valid?: true, changes: changes} = changeset) do
    entries = changes[:entries] |> Enum.map(& &1.changes)
    debits = amount_sum(entries, :debit_amount)
    credits = amount_sum(entries, :credit_amount)

    if D.equal?(debits, credits) do
      put_change(changeset, :amount, debits)
    else
      add_error(changeset, :entries, "debit total must equal credit total")
    end
  end

  defp amount_sum(entries, key),
    do:
      entries
      |> Enum.map(& &1[key])
      |> Enum.filter(&(!is_nil(&1)))
      |> Enum.reduce(&D.add/2)
end
