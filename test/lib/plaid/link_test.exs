defmodule Plaid.LinkTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test "create_link_token/1 request POST and returns map", %{bypass: bypass} do
    body = http_response_body(:create_link_token)

    Bypass.expect(bypass, fn conn ->
      assert "POST" == conn.method
      assert "link/token/create" == Enum.join(conn.path_info, "/")
      Plug.Conn.resp(conn, 200, Poison.encode!(body))
    end)

    assert {:ok, resp} =
             Plaid.Link.create_link_token(%{
               client_name: "My App",
               country_codes: ["US"],
               language: "en",
               products: ["transactions"],
               user: %{client_user_id: "UNIQUE_USER_ID"},
               webhook: "https://sample.webhook.com"
             })

    assert resp.link_token == body["link_token"]
    assert resp.created_at == body["created_at"]
    assert resp.expiration == body["expiration"]
    assert resp.metadata == body["metadata"]
  end

  test "get_link_token/1 request POST and returns map", %{bypass: bypass} do
    body = http_response_body(:get_link_token)

    Bypass.expect(bypass, fn conn ->
      assert "POST" == conn.method
      assert "link/token/get" == Enum.join(conn.path_info, "/")
      Plug.Conn.resp(conn, 200, Poison.encode!(body))
    end)

    assert {:ok, resp} =
             Plaid.Link.get_link_token(%{
               link_token: "link-token"
             })

    assert resp.link_token == body["link_token"]
    assert resp.created_at == body["created_at"]
    assert resp.expiration == body["expiration"]
    assert resp.metadata == body["metadata"]
  end
end
