defmodule Plaid.Mixfile do
  use Mix.Project

  @description """
    An Elixir Library for Plaid
  """

  def project do
    [app: :plaid,
     version: "0.2.0",
     description: @description,
     package: package(),
     elixir: "~> 1.3",
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       "coveralls": :test,
       "coveralls.detail": :test,
       "coveralls.post": :test,
       "coveralls.html": :test,
       vcr: :test,
       "vcr.delete": :test,
       "vcr.check": :test,
       "vcr.show": :test
     ],
     deps: deps()
    ]
  end

  def application do
    [applications: [:httpoison]]
  end

  defp deps do
    [
     {:httpoison, "~> 0.9.0"},
     {:poison, "~> 2.0"},
     {:exvcr, "~> 0.7", only: :test},
     {:ex_doc, "~> 0.13", only: :dev},
     {:excoveralls, "~> 0.5", only: :test}
    ]
  end

  defp package do
    [
      name: :plaid_elixir,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      licenses: ["MIT"],
      maintainers: ["Will Gilman"],
      links: %{"Github" => "https://github.com/wfgilman/plaid-elixir"}
    ]
  end
end
