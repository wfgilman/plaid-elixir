defmodule Plaid.AuthTest do
  use ExUnit.Case, async: true

  import Mox

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
    test "makes post call to auth/get endpoint", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "auth/get"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :auth
        {:ok, %Plaid.Auth{}}
      end)

      assert {:ok, %Plaid.Auth{}} = Plaid.Auth.get(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Auth.get(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Auth data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:accounts)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Auth{}} = Plaid.Auth.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Auth.get(params, config)
    end
  end
end
