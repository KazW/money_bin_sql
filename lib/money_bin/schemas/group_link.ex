defmodule MoneyBin.Schemas.GroupLink do
  use MoneyBin, :schema

  schema @tables[:group_link] do
    belongs_to(:account, @schemas[:account])
    belongs_to(:group, @schemas[:group])

    field(:credit, :boolean)
    field(:name, :string)

    timestamps()
  end

  @fields [:account_id, :group_id, :credit, :name]

  @doc false
  def changeset(link \\ %__MODULE__{}, attrs) do
    link
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> constrained_assoc_cast(:account)
    |> constrained_assoc_cast(:group)
    |> unique_constraint(:name, name: :account_group_links_group_id_name_index)
  end
end
