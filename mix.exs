defmodule Plaid.Mixfile do
  use Mix.Project

  @description """
    An Elixir Library for Plaid's V2 API
  """

  def project do
    [app: :plaid,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     description: @description,
     elixir: "~> 1.5",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env in [:prod, :sandbox],
     start_permanent: Mix.env in [:prod, :sandbox],
     deps: deps(),
     dialyzer: [plt_add_deps: false],
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.0"},
      {:bypass, "~> 0.8", only: [:test]},
      {:common, in_umbrella: true}
    ]
  end
end
