defmodule Plaid.CategoriesTest do
  use ExUnit.Case, async: true

  import Mox

  setup do
    verify_on_exit!()
    {:ok, %{config: %{client: PlaidMock}}}
  end

  @moduletag :categories

  @tag :unit
  test "categories data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.Categories{
               categories: [%Plaid.Categories.Category{}]
             })
  end

  describe "categories get/1" do
    @tag :unit
    test "makes post call to categories/get endpoint", %{config: config} do
      PlaidMock
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "categories/get"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :categories
        {:ok, %Plaid.Categories{}}
      end)

      assert {:ok, %Plaid.Categories{}} = Plaid.Categories.get(config)
    end

    @tag :integration
    test "returns Plaid.Categories data structure" do
      bypass = Bypass.open()

      body = Plaid.Factory.http_response_body(:categories)

      config = %{root_uri: "http://localhost:#{bypass.port}/"}

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Categories{}} = Plaid.Categories.get(config)
    end

    @tag :integration
    test "returns Plaid.Error" do
      bypass = Bypass.open()

      body = Plaid.Factory.http_response_body(:error)

      config = %{root_uri: "http://localhost:#{bypass.port}/"}

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Categories.get(config)
    end
  end
end
