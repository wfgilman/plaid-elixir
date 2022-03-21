defmodule Plaid.WebhookVerificationKeyTest do
  use ExUnit.Case, async: true

  import Mox

  setup do
    verify_on_exit!()
    {:ok, params: %{access_token: "my-token"}, config: %{client: PlaidMock}}
  end

  @moduletag :webhook_verification_key

  @tag :unit
  test "webhook_verification_key data structure encodes with Jason" do
    assert {:ok, _} = Jason.encode(%Plaid.WebhookVerificationKey{})
  end

  describe "webhook_verification_key get/2" do
    @tag :unit
    test "make post request to webhook_verification_key/get endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "webhook_verification_key/get"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :webhook_verification_key
        {:ok, %Plaid.WebhookVerificationKey{}}
      end)

      assert {:ok, %Plaid.WebhookVerificationKey{}} =
               Plaid.WebhookVerificationKey.get(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.WebhookVerificationKey.get(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.WebhookVerificationKey data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:webhook_verification_key)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.WebhookVerificationKey{}} =
               Plaid.WebhookVerificationKey.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.WebhookVerificationKey.get(params, config)
    end
  end
end
