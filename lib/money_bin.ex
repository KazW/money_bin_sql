defmodule MoneyBin do
  def config_variables do
    quote do
      @repo Application.get_env(:money_bin, MoneyBin)[:repo]
      @tables Keyword.merge(
                [
                  ledger: "ledgers",
                  transaction: "transactions",
                  journal_entry: "journal_entries",
                  chart: "charts",
                  chart_member: "chart_members"
                ],
                Application.get_env(:money_bin, MoneyBin)[:tables] || []
              )
      @schemas Keyword.merge(
                 [
                   ledger: MoneyBin.Schemas.Ledger,
                   transaction: MoneyBin.Schemas.Transaction,
                   journal_entry: MoneyBin.Schemas.JournalEntry,
                   chart: MoneyBin.Schemas.Chart,
                   chart_member: MoneyBin.Schemas.ChartMember
                 ],
                 Application.get_env(:money_bin, MoneyBin)[:schemas] || []
               )
    end
  end

  def schema do
    quote do
      use MoneyBin, :config_variables
      use Ecto.Schema
      import Ecto.Changeset
      alias Decimal, as: D

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      def constrained_assoc_cast(%{valid?: false} = changeset, _), do: changeset

      def constrained_assoc_cast(%{valid?: true} = changeset, assoc) when is_atom(assoc),
        do: changeset |> cast_assoc(assoc) |> assoc_constraint(assoc)
    end
  end

  def service do
    quote do
      use MoneyBin, :config_variables

      alias Decimal, as: D
      alias MoneyBin.Ledger
      alias MoneyBin.Transaction

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      defmacro coalesce(left, right) do
        quote do
          fragment("COALESCE(?, ?)", unquote(left), unquote(right))
        end
      end

      def find(%_{id: id}), do: find(id)

      defp to_model(%_{} = struct), do: Map.from_struct(struct) |> to_model
      defp to_model(other) when is_nil(other), do: other
    end
  end

  def model do
    quote do
      use Ecto.Schema
      import Ecto.Changeset

      @primary_key false
    end
  end

  @doc false
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
