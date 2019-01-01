Logger.configure(level: :info)
ExUnit.configure(timeout: :infinity)
ExUnit.start()
{:ok, _pid} = MoneyBinSQL.Test.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(MoneyBinSQL.Test.Repo, :manual)

if System.get_env("PRY") do
  Code.eval_file("test/support/pry.exs")
end
