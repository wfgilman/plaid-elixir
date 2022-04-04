defmodule Plaid.AuthTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

  setup do
    verify_on_exit!()
    {:ok, params: %{access_token: "my-token"}, config: %{client: PlaidMock}}
  end

  @moduletag :auth

  test "auth data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.Auth{
               accounts: [%Plaid.Accounts.Account{}],
               item: %Plaid.Item{},
               numbers: %Plaid.Auth.Numbers{
                 ach: [%Plaid.Auth.Numbers.ACH{}],
                 eft: [%Plaid.Auth.Numbers.EFT{}],
                 international: [%Plaid.Auth.Numbers.International{}],
                 bacs: [%Plaid.Auth.Numbers.BACS{}]
               }
             })
  end

  describe "auth get/2" do
    @tag :unit
    test "submits request with correct parameters", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "auth/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:auth)}
      end)

      assert {:ok, ds} = Plaid.Auth.get(params, config)
      assert Plaid.Auth == ds.__struct__
      assert Plaid.Accounts.Account == List.first(ds.accounts).__struct__
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

      body = http_response_body(:accounts)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Auth{}} = Plaid.Auth.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Auth.get(params, config)
    end
  end
end
