defmodule MoneyBin.Transaction do
  use MoneyBin, :model

  embedded_schema do
    field(:id, :binary_id)
    field(:amount, :decimal)
    embeds_many(:entries, MoneyBin.JournalEntry)
    timestamps(type: :utc_datetime)
  end

  @fields [:id, :inserted_at, :updated_at]

  @doc false
  def new(record \\ %__MODULE__{}, attrs) do
    entries = attrs[:entries] |> Enum.map(&Map.from_struct/1)

    record
    |> cast(attrs, @fields)
    |> put_embed(:entries, entries)
    |> apply_changes
  end
end
