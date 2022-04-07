defmodule Plaid.IncomeTest do
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

  @moduletag :income

  @tag :unit
  test "income data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.Income{
               item: %Plaid.Item{},
               income: %Plaid.Income.Income{
                 income_streams: [%Plaid.Income.Income.IncomeStream{}]
               }
             })
  end

  describe "income get/2" do
    @tag :unit
    test "sends request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "income/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:income)
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.Income.get(params, config)
      assert Plaid.Income == ds.__struct__
      assert Plaid.Item == ds.item.__struct__
      assert Plaid.Income.Income == ds.income.__struct__
      assert Plaid.Income.Income.IncomeStream = List.first(ds.income.income_streams).__struct__
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:income)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Income{}} = Plaid.Income.get(params, config)
    end

    @tag :integration
    test "error integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Income.get(params, config)
    end
  end
end
