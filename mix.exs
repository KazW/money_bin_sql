defmodule MoneyBin.MixProject do
  use Mix.Project

  @version "0.0.1"

  def project do
    [
      app: :money_bin,
      version: @version,
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: production?(),
      start_permanent: production?(),
      preferred_cli_env: [ex_doc: :test],
      deps: deps(),
      aliases: aliases(),

      # Hex
      description: "Flexible double entry based accounting for Ecto.",
      package: package(),

      # Docs
      name: "MoneyBin",
      docs: [
        source_ref: "v#{@version}",
        main: "readme",
        logo: "logo.png",
        canonical: "https://hexdocs.pm/money_bin",
        source_url: "https://github.com/KazW/money_bin",
        extras: ["README.md"]
      ]
    ]
  end

  defp production?, do: Mix.env() == :prod

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [extra_applications: extra_applications(Mix.env())]
  end

  defp extra_applications(:test), do: [:postgrex, :ecto, :logger]
  defp extra_applications(_), do: [:logger]

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.18.0", only: :dev, runtime: false},
      {:ecto, "~> 2.2"},
      {:postgrex, ">= 0.0.0"},
      {:poison, "~> 3.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.reset": ["ecto.drop --quiet", "ecto.create --quiet", "ecto.migrate --quiet"],
      test: ["ecto.reset", "test"]
    ]
  end

  defp package do
    [
      maintainers: ["Kaz Walker"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/KazW/money_bin"},
      files: ~w(lib) ++ ~w(LICENSE.md mix.exs README.md)
    ]
  end
end
