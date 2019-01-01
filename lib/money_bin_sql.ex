defmodule MoneyBinSQL do
  @moduledoc false

  def config_variables do
    quote do
      @repo Application.get_env(:money_bin_sql, :settings)[:repo]

      @tables [
                account: "accounts",
                transaction: "transactions",
                journal_entry: "journal_entries",
                ledger: "ledgers",
                ledger_member: "ledger_members"
              ]
              |> Keyword.merge(Application.get_env(:money_bin_sql, :settings)[:tables] || [])

      @schemas [
                 account: MoneyBinSQL.Account,
                 transaction: MoneyBinSQL.Transaction,
                 journal_entry: MoneyBinSQL.JournalEntry,
                 ledger: MoneyBinSQL.Ledger,
                 ledger_member: MoneyBinSQL.LedgerMember
               ]
               |> Keyword.merge(Application.get_env(:money_bin_sql, :settings)[:schemas] || [])
    end
  end

  def schema do
    quote do
      use MoneyBinSQL, :config_variables
      use Ecto.Schema
      import Ecto.Changeset
      alias Decimal, as: D

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id

      defp constrained_assoc_cast(%{valid?: false} = changeset, _), do: changeset

      defp constrained_assoc_cast(%{valid?: true} = changeset, assoc) when is_atom(assoc),
        do: changeset |> cast_assoc(assoc) |> assoc_constraint(assoc)
    end
  end

  def service do
    quote do
      use MoneyBinSQL, :config_variables

      alias Decimal, as: D
      alias MoneyBinSQL.Account
      alias MoneyBinSQL.Transaction

      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      defmacrop coalesce(left, right) do
        quote do
          fragment("COALESCE(?, ?)", unquote(left), unquote(right))
        end
      end

      def find(%Ecto.Changeset{} = changeset), do: changeset
      def find(%_{id: id}), do: find(id)
      defp unwrap({_, res}), do: res
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
