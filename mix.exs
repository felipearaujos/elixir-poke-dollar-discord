defmodule PokeDollar.MixProject do
  use Mix.Project

  def project do
    [
      app: :poke_dollar_bot,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison],
      mod: {PokeDollar, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nostrum, "~> 0.4"},
      {:httpoison, "~> 1.6"},
      {:poison, "~> 3.1"}
    ]
  end
end
