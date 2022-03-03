defmodule Plaid.ErrorTest do
  use ExUnit.Case, async: true

  @moduletag :error

  @tag :unit
  test "error data structure encodes with Jason" do
    assert {:ok, _} = Jason.encode(%Plaid.Error{})
  end
end
