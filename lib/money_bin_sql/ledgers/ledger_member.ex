defmodule MoneyBinSQL.LedgerMember do
  use MoneyBinSQL, :schema
  @moduledoc false

  schema @tables[:ledger_member] do
    belongs_to(:account, @schemas[:account])
    belongs_to(:ledger, @schemas[:ledger])

    field(:credit, :boolean, default: false)

    timestamps()
  end

  @fields [:account_id, :ledger_id, :credit]
  @required_fields [:account_id, :credit]

  @doc false
  def changeset(link \\ %__MODULE__{}, attrs) do
    link
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> constrained_assoc_cast(:account)
    |> constrained_assoc_cast(:ledger)
    |> unique_constraint(:account_id, name: :ledger_members_ledger_id_account_id_index)
  end
end
