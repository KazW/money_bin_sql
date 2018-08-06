defmodule MoneyBin.Chart do
  use MoneyBin, :schema

  schema @tables[:chart] do
    timestamps()
  end

  @doc false
  def changeset(record \\ %__MODULE__{}, attrs), do: record |> cast(attrs, [])
end
