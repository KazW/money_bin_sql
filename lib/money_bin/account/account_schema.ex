defmodule MoneyBin.Schemas.Account do
  use MoneyBin, :schema

  schema @tables[:account] do
    timestamps()
  end

  @doc false
  def changeset(record \\ %__MODULE__{}, attrs), do: record |> cast(attrs, [])
end
