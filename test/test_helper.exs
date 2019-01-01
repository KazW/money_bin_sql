Logger.configure(level: :info)
ExUnit.configure(timeout: :infinity)
ExUnit.start()
{:ok, _pid} = MoneyBin.Test.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(MoneyBin.Test.Repo, :manual)

if System.get_env("PRY") do
  Code.eval_file("test/support/pry.exs")
end
