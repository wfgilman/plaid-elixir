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
      Bypass.expect bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end

      assert {:ok, resp} = Plaid.Item.get(%{access_token: "my-token"})
      assert Plaid.Item == resp.__struct__
    end

    test "exchange_public_token/1 requests POST and returns map", %{bypass: bypass} do
      body = http_response_body(:exchange_public_token)
      Bypass.expect bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end

      assert {:ok, resp} = Plaid.Item.exchange_public_token(%{public_token: "public-token"})
      assert resp.access_token == body["access_token"]
      assert resp.item_id == body["item_id"]
      assert resp.request_id == body["request_id"]
    end

    test "create_public_token/1 request POST and returns map", %{bypass: bypass} do
      body = http_response_body(:create_public_token)
      Bypass.expect bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end

      assert {:ok, resp} = Plaid.Item.create_public_token(%{access_token: "my-token"})
      assert resp.public_token == body["public_token"]
      assert resp.expiration == body["expiration"]
      assert resp.request_id == body["request_id"]
    end

    test "update_webhook/1 requests POST and returns Plaid.Item", %{bypass: bypass} do
      body = http_response_body(:webhook)
      Bypass.expect bypass, fn conn ->
        {:ok, req_body, _conn} = Plug.Conn.read_body(conn)
        assert "POST" == conn.method
        assert String.starts_with? req_body, "{\"webhook\":\"https://plaid.com/updated/hook\""
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end

      params = %{access_token: "my-token", webhook: "https://plaid.com/updated/hook"}
      assert {:ok, resp} = Plaid.Item.update_webhook(params)
      assert Plaid.Item == resp.__struct__
    end

    test "rotate_access_token/1 requests POST and returns success", %{bypass: bypass} do
      body = http_response_body(:rotate_access_token)
      Bypass.expect bypass, fn conn ->
        {:ok, req_body, _conn} = Plug.Conn.read_body(conn)
        assert "POST" == conn.method
        assert String.ends_with? req_body, "\"access_token\":\"my-token\"}"
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end

      assert {:ok, resp} = Plaid.Item.rotate_access_token(%{access_token: "my-token"})
      assert resp.new_access_token == body["new_access_token"]
    end

    test "update_version_access_token/1 requests POST and returns success", %{bypass: bypass} do
      body = http_response_body(:update_version_access_token)
      Bypass.expect bypass, fn conn ->
        {:ok, req_body, _conn} = Plug.Conn.read_body(conn)
        assert "POST" == conn.method
        assert String.ends_with? req_body, "\"access_token_v1\":\"my-token\"}"
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end

      assert {:ok, resp} = Plaid.Item.update_version_access_token(%{access_token_v1: "my-token"})
      assert resp.access_token == body["access_token"]
    end

    test "delete/1 requests POST and returns success", %{bypass: bypass} do
      body = http_response_body(:delete)
      Bypass.expect bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end

      assert {:ok, resp} = Plaid.Item.delete(%{access_token: "my-token"})
      assert resp.deleted == body["deleted"]
    end

    test "create_processor_token/1 request POST and returns token", %{bypass: bypass} do
      body = http_response_body(:processor_token)
      Bypass.expect bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end

      assert {:ok, resp} = Plaid.Item.create_processor_token(%{access_token: "token", account_id: "id"})
      assert resp.processor_token
    end
  end
end
