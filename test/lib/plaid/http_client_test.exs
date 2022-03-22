defmodule Plaid.HTTPClientTest do
  use ExUnit.Case, async: true

  @moduletag :http_client

  @tag :unit
  test "response data structure encodes with Jason" do
    assert {:ok, _} = Jason.encode(%Plaid.HTTPClient.Response{})
  end

  @tag :unit
  test "error data structure encodes with Jason" do
    assert {:ok, _} = Jason.encode(%Plaid.HTTPClient.Error{})
  end

  describe "plaid http error" do
    @tag :unit
    test "Plaid.HTTPClient.Error generates message when reason is provided" do
      assert_raise Plaid.HTTPClient.Error, "http request failed with reason: :econnrefused", fn ->
        raise Plaid.HTTPClient.Error, reason: :econnrefused
      end
    end

    @tag :unit
    test "Plaid.HTTPClient.Error accepts message provided" do
      assert_raise Plaid.HTTPClient.Error, "This is a custom error message", fn ->
        raise Plaid.HTTPClient.Error, message: "This is a custom error message"
      end
    end
  end
end
