defmodule MoneyBin.Transaction do
  use MoneyBin, :model

  embedded_schema do
    field(:id, :binary_id)
    field(:settled_at, :utc_datetime)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def new(record \\ %__MODULE__{}, attrs),
    do: record |> cast(attrs, __schema__(:fields)) |> apply_changes
end
