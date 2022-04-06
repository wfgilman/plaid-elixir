defmodule Plaid.WebhookVerificationKeyTest do
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

  @moduletag :webhook_verification_key

  @tag :unit
  test "webhook_verification_key data structure encodes with Jason" do
    assert {:ok, _} = Jason.encode(%Plaid.WebhookVerificationKey{})
  end

  describe "webhook_verification_key get/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "webhook_verification_key/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:webhook_verification_key)}
      end)

      assert {:ok, ds} = Plaid.WebhookVerificationKey.get(params, config)
      assert Plaid.WebhookVerificationKey == ds.__struct__
      assert ds.key
      assert ds.request_id
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:webhook_verification_key)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, ds} = Plaid.WebhookVerificationKey.get(params, config)
      assert Plaid.WebhookVerificationKey == ds.__struct__
      assert ds.key
      assert ds.request_id
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

      assert {:error, %Plaid.Error{}} = Plaid.WebhookVerificationKey.get(params, config)
    end
  end
end
