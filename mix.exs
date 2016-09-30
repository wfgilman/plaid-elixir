defmodule Plaid.Mixfile do
  use Mix.Project

  @description """
    An Elixir Library for Plaid
  """

  def project do
    [app: :plaid,
     version: "0.1.0",
     elixir: "~> 1.3",
     deps: deps(),
     description: @description,
     preferred_cli_env: [
       vcr: :test, "vcr.delete": :test, "vcr.check": :test, "vcr.show": :test
     ]
    ]
  end

  def application do
    [applications: [:logger, :httpoison, :ecto, :poison]]
  end

  defp deps do
    [
     {:httpoison, "~> 0.9.0"},
     {:ecto, "~> 2.0.0"},
     {:poison, "~> 2.0"},
     {:exvcr, "~> 0.7", only: :test},
     {:ex_doc, "~> 0.13", only: :dev}
    ]
  end

end
