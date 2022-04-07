defmodule Plaid.Investments.HoldingsTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

  setup do
    verify_on_exit!()

    {:ok,
     params: %{access_token: "my-token"},
     config: %{
       client: PlaidMock,
       client_id: "test_id",
       secret: "test_secret",
       root_uri: "http://localhost:4000/"
     }}
  end

  @moduletag :"investments/holdings"

  @tag :unit
  test "investments/holdings data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.Investments.Holdings{
               accounts: [%Plaid.Accounts.Account{}],
               item: %Plaid.Item{},
               securities: [%Plaid.Investments.Security{}],
               holdings: [%Plaid.Investments.Holdings{}]
             })
  end

  describe "investments/holdings get/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "investments/holdings/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:"investments/holdings")
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.Investments.Holdings.get(params, config)
      assert Plaid.Investments.Holdings == ds.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
      assert Plaid.Investments.Security == List.first(ds.securities).__struct__
      assert Plaid.Investments.Holdings.Holding == List.first(ds.holdings).__struct__
      assert Plaid.Item == ds.item.__struct__
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:"investments/holdings")

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Investments.Holdings{}} = Plaid.Investments.Holdings.get(params, config)
    end

    @tag :integration
    test "returns Plaid.Error", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Investments.Holdings.get(params, config)
    end
  end
end
