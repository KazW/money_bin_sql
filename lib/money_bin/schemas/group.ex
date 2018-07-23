defmodule MoneyBin.Schemas.Group do
  use MoneyBin, :schema

  schema @tables[:group] do
    timestamps()
  end

  @doc false
  def changeset(record \\ %__MODULE__{}, attrs), do: record |> cast(attrs, [])
end
