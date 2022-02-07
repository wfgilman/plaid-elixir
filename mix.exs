defmodule Plaid.Mixfile do
  use Mix.Project

  @source_url "https://github.com/wfgilman/plaid-elixir"

  def project do
    [
      app: :plaid,
      version: "2.5.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test, "coveralls.detail": :test]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:httpoison, "~> 1.4"},
      {:poison, "~> 4.0"},
      {:jason, "~> 1.1"},
      {:bypass, "~> 0.8", only: [:test]},
      {:credo, "~> 0.5", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.6", only: [:test]},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      {:telemetry, "~> 1.0"},
      {:uuid, "~> 1.1", only: [:test]}
    ]
  end

  defp package do
    [
      description: "An Elixir Library for Plaid's V2 API",
      name: :plaid_elixir,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      maintainers: ["Will Gilman"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"],
        "parameters.md": []
      ],
      main: "readme",
      logo: "assets/plaid-logo.png",
      source_url: @source_url,
      source_ref: "master",
      formatters: ["html"]
    ]
  end
end
