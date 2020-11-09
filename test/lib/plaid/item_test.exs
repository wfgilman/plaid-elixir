defmodule Plaid.ItemTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "item" do
    test "get/1 requests POST and returns Plaid.Item", %{bypass: bypass} do
      body = http_response_body(:item)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "item/get" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Item.get(%{access_token: "my-token"})
      assert Plaid.Item == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
      assert Plaid.Item.Status == resp.status.__struct__
      assert Plaid.Item.Status.Investments == resp.status.investments.__struct__
      assert Plaid.Item.Status.Transactions == resp.status.transactions.__struct__
      assert Plaid.Item.Status.LastWebhook == resp.status.last_webhook.__struct__
      assert resp.status.last_webhook.code_sent == body["status"]["last_webhook"]["code_sent"]
    end

    test "exchange_public_token/1 requests POST and returns map", %{bypass: bypass} do
      body = http_response_body(:exchange_public_token)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "item/public_token/exchange" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Item.exchange_public_token(%{public_token: "public-token"})
      assert resp.access_token == body["access_token"]
      assert resp.item_id == body["item_id"]
      assert resp.request_id == body["request_id"]
    end

    test "create_public_token/1 request POST and returns map", %{bypass: bypass} do
      body = http_response_body(:create_public_token)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "item/public_token/create" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Item.create_public_token(%{access_token: "my-token"})
      assert resp.public_token == body["public_token"]
      assert resp.expiration == body["expiration"]
      assert resp.request_id == body["request_id"]
    end

    test "update_webhook/1 requests POST and returns Plaid.Item", %{bypass: bypass} do
      body = http_response_body(:webhook)

      Bypass.expect(bypass, fn conn ->
        {:ok, req_body, _conn} = Plug.Conn.read_body(conn)
        assert "POST" == conn.method
        assert "item/webhook/update" == Enum.join(conn.path_info, "/")
        assert String.starts_with?(req_body, "{\"webhook\":\"https://plaid.com/updated/hook\"")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      params = %{access_token: "my-token", webhook: "https://plaid.com/updated/hook"}
      assert {:ok, resp} = Plaid.Item.update_webhook(params)
      assert Plaid.Item == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end

    test "rotate_access_token/1 requests POST and returns success", %{bypass: bypass} do
      body = http_response_body(:rotate_access_token)

      Bypass.expect(bypass, fn conn ->
        {:ok, req_body, _conn} = Plug.Conn.read_body(conn)
        assert "POST" == conn.method
        assert "item/access_token/invalidate" == Enum.join(conn.path_info, "/")
        assert String.ends_with?(req_body, "\"access_token\":\"my-token\"}")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Item.rotate_access_token(%{access_token: "my-token"})
      assert resp.new_access_token == body["new_access_token"]
    end

    test "update_version_access_token/1 requests POST and returns success", %{bypass: bypass} do
      body = http_response_body(:update_version_access_token)

      Bypass.expect(bypass, fn conn ->
        {:ok, req_body, _conn} = Plug.Conn.read_body(conn)
        assert "POST" == conn.method
        assert "item/access_token/update_version" == Enum.join(conn.path_info, "/")
        assert String.ends_with?(req_body, "\"access_token_v1\":\"my-token\"}")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Item.update_version_access_token(%{access_token_v1: "my-token"})
      assert resp.access_token == body["access_token"]
    end

    test "remove/1 requests POST and returns success", %{bypass: bypass} do
      body = http_response_body(:remove)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "item/remove" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Item.remove(%{access_token: "my-token"})
      assert resp.request_id == body["request_id"]
    end

    test "deprecated: create_processor_token/1 request POST and returns token", %{bypass: bypass} do
      body = http_response_body(:processor_token)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "processor/dwolla/processor_token/create" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} =
               Plaid.Item.create_processor_token(%{access_token: "token", account_id: "id"})

      assert resp.processor_token
    end

    test "create_processor_token/3 request POST and returns token", %{bypass: bypass} do
      body = http_response_body(:processor_token)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "processor/dwolla/processor_token/create" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} =
               Plaid.Item.create_processor_token(
                 %{access_token: "token", account_id: "id"},
                 :dwolla,
                 %{}
               )

      assert resp.processor_token
    end

    test "create_stripe_bank_account_token/1 request POST and returns token", %{bypass: bypass} do
      body = http_response_body(:stripe_bank_account_token)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "processor/stripe/bank_account_token/create" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} =
               Plaid.Item.create_stripe_bank_account_token(%{
                 access_token: "token",
                 account_id: "id"
               })

      assert resp.stripe_bank_account_token
    end
  end
end
