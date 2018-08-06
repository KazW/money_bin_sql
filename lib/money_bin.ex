defmodule MoneyBin do
  def config_variables do
    quote do
      @repo Application.get_env(:money_bin, MoneyBin)[:repo]
      @tables Keyword.merge(
                [
                  account: "accounts",
                  transaction: "transactions",
                  journal_entry: "journal_entries",
                  ledger: "ledgers",
                  ledger_member: "ledger_members"
                ],
                Application.get_env(:money_bin, MoneyBin)[:tables] || []
              )
      @schemas Keyword.merge(
                 [
                   account: MoneyBin.Account,
                   transaction: MoneyBin.Transaction,
                   journal_entry: MoneyBin.JournalEntry,
                   ledger: MoneyBin.Ledger,
                   ledger_member: MoneyBin.LedgerMember
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
      alias MoneyBin.Account
      alias MoneyBin.Transaction

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      defmacro coalesce(left, right) do
        quote do
          fragment("COALESCE(?, ?)", unquote(left), unquote(right))
        end
      end

      def find(%Ecto.Changeset{} = changeset), do: changeset
      def find(%_{id: id}), do: find(id)
      defp unwrap({_, res}), do: res
    end
  end

  @doc false
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
