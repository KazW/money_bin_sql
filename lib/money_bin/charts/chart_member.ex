defmodule MoneyBin.ChartMember do
  use MoneyBin, :schema

  schema @tables[:chart_member] do
    belongs_to(:ledger, @schemas[:ledger])
    belongs_to(:chart, @schemas[:chart])

    field(:credit, :boolean)
    field(:name, :string)

    timestamps()
  end

  @fields [:ledger_id, :chart_id, :credit, :name]

  @doc false
  def changeset(link \\ %__MODULE__{}, attrs) do
    link
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> constrained_assoc_cast(:ledger)
    |> constrained_assoc_cast(:chart)
    |> unique_constraint(:name, name: :ledger_chart_members_chart_id_name_index)
  end
end
