defmodule MoneyBin.LedgerMember do
  use MoneyBin, :schema

  schema @tables[:ledger_member] do
    belongs_to(:account, @schemas[:account])
    belongs_to(:ledger, @schemas[:ledger])

    field(:credit, :boolean)
    field(:name, :string)

    timestamps()
  end

  @fields [:account_id, :ledger_id, :credit, :name]

  @doc false
  def changeset(link \\ %__MODULE__{}, attrs) do
    link
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> constrained_assoc_cast(:account)
    |> constrained_assoc_cast(:ledger)
    |> unique_constraint(:name, name: :account_ledger_members_ledger_id_name_index)
  end
end
