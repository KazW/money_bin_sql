defmodule MoneyBin do
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
      alias MoneyBin.Account

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def model do
    quote do
      use Ecto.Schema
      use MoneyBin, :config_variables

      import Ecto.Changeset

      @primary_key false
    end
  end

  def config_variables do
    quote do
      @repo Application.get_env(:money_bin, MoneyBin)[:repo]
      @tables Application.get_env(:money_bin, MoneyBin)[:tables]
      @schemas Application.get_env(:money_bin, MoneyBin)[:schemas]
    end
  end

  @doc false
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
