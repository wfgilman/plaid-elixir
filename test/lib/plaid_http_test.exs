defmodule PlaidHTTPTest do
  use ExUnit.Case, async: true

  @moduletag :plaid_http

  @tag :unit
  test "response data structure encodes with Jason" do
    assert {:ok, _} = Jason.encode(%PlaidHTTP.Response{})
  end

  @tag :unit
  test "error data structure encodes with Jason" do
    assert {:ok, _} = Jason.encode(%PlaidHTTP.Error{})
  end

  describe "plaid http error" do
    @tag :unit
    test "PlaidHTTP.Error generates message when reason is provided" do
      assert_raise PlaidHTTP.Error, "http request failed with reason: :econnrefused", fn ->
        raise PlaidHTTP.Error, reason: :econnrefused
      end
    end

    @tag :unit
    test "PlaidHTTP.Error accepts message provided" do
      assert_raise PlaidHTTP.Error, "This is a custom error message", fn ->
        raise PlaidHTTP.Error, message: "This is a custom error message"
      end
    end
  end
end
