defmodule MoneyBinSQL.Test.Repo do
  use Ecto.Repo,
    otp_app: :money_bin_sql,
    adapter: Ecto.Adapters.Postgres
end
