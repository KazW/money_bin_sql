defmodule MoneyBin.Test.Repo do
  use Ecto.Repo,
    otp_app: :money_bin,
    adapter: Ecto.Adapters.Postgres
end
