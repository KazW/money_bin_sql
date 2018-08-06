defmodule MoneyBinDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :money_bin_demo,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {MoneyBinDemo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:money_bin, path: "../../"}
    ]
  end
end
