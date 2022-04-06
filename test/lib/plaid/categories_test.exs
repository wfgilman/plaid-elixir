defmodule Plaid.CategoriesTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

  setup do
    verify_on_exit!()

    {:ok,
     %{
       config: %{
         client: PlaidMock,
         client_id: "test_id",
         secret: "test_secret",
         root_uri: "http://localhost:4000/"
       }
     }}
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
    test "submits request and unmarshalls response", %{config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "categories/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:categories)}
      end)

      assert {:ok, ds} = Plaid.Categories.get(config)
      assert Plaid.Categories == ds.__struct__
      assert Plaid.Categories.Category = List.first(ds.categories).__struct__
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      body = http_response_body(:categories)

      config = %{root_uri: "http://localhost:#{bypass.port}/"}

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Categories{}} = Plaid.Categories.get(config)
    end

    @tag :integration
    test "error integration test" do
      bypass = Bypass.open()

      body = http_response_body(:error)

      config = %{root_uri: "http://localhost:#{bypass.port}/"}

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Categories.get(config)
    end
  end
end
