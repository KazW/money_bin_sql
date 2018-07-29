defmodule MoneyBin do
  def config_variables do
    quote do
      @repo Application.get_env(:money_bin, MoneyBin)[:repo]
      @tables Keyword.merge(
                [
                  ledger: "ledgers",
                  transaction: "transactions",
                  journal_entry: "journal_entries",
                  group: "groups",
                  group_link: "ledger_group_links"
                ],
                Application.get_env(:money_bin, MoneyBin)[:tables] || []
              )
      @schemas Keyword.merge(
                 [
                   ledger: MoneyBin.Schemas.Ledger,
                   transaction: MoneyBin.Schemas.Transaction,
                   journal_entry: MoneyBin.Schemas.JournalEntry,
                   group: MoneyBin.Schemas.Group,
                   group_link: MoneyBin.Schemas.GroupLink
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

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      def constrained_assoc_cast(%{valid?: false} = changeset, _), do: changeset

      def constrained_assoc_cast(%{valid?: true} = changeset, assoc) when is_atom(assoc) do
        changeset |> cast_assoc(assoc) |> assoc_constraint(assoc)
      end
    end
  end

  def service do
    quote do
      use MoneyBin, :config_variables

      alias Decimal, as: D
      alias MoneyBin.Ledger

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      defmacro coalesce(left, right) do
        quote do
          fragment("COALESCE(?, ?)", unquote(left), unquote(right))
        end
      end
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
