defmodule MoneyBin.Schemas.Ledger do
  use MoneyBin, :schema

  schema @tables[:ledger] do
    timestamps()
  end

  @doc false
  def changeset(record \\ %__MODULE__{}, attrs), do: record |> cast(attrs, [])
end
