defmodule Plaid.IdentityTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "identity" do
    test "get/1 requests POST and returns Plaid.Identity", %{bypass: bypass} do
      body = http_response_body(:identity)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        assert "identity/get" == Enum.join(conn.path_info, "/")
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Identity.get(%{access_token: "my-token"})
      assert Plaid.Identity == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)
    end
  end
end
