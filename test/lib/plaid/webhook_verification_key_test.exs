defmodule Plaid.WebhookVerificationKeyTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  test "get/1 request POST and returns map", %{bypass: bypass} do
    body = http_response_body(:webhook_verification_key)

    Bypass.expect(bypass, fn conn ->
      assert "POST" == conn.method
      assert "webhook_verification_key/get" == Enum.join(conn.path_info, "/")
      Plug.Conn.resp(conn, 200, Poison.encode!(body))
    end)

    assert {:ok, resp} =
             Plaid.WebhookVerificationKey.get(%{
               key_id: "bfbd5111-8e33-4643-8ced-b2e642a72f3c"
             })

    assert resp.key == body["key"]
    assert resp.request_id == body["request_id"]
  end
end
