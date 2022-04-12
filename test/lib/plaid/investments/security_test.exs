defmodule Plaid.Investments.SecurityTest do
  use ExUnit.Case, async: true

  @moduletag :"investments/security"

  @tag :unit
  test "security data structure encodes with Jason" do
    assert {:ok, _} = Jason.encode(%Plaid.Investments.Security{})
  end
end
