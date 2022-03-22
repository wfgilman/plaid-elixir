defmodule Plaid.Investments.HoldingsTest do
  use ExUnit.Case, async: true

  import Mox

  setup do
    verify_on_exit!()
    {:ok, params: %{access_token: "my-token"}, config: %{client: PlaidMock}}
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
    test "makes post request to investments/holdings/get endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "investments/holdings/get"
        {:ok, %Plaid.HTTPClient.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :"investments/holdings"
        {:ok, %Plaid.Investments.Holdings{}}
      end)

      assert {:ok, %Plaid.Investments.Holdings{}} = Plaid.Investments.Holdings.get(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Investments.Holdings.get(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Investments.Holdings data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:"investments/holdings")

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
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
        Plug.Conn.resp(conn, 400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Investments.Holdings.get(params, config)
    end
  end
end
