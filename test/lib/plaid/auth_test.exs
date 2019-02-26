defmodule Plaid.AuthTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "auth" do
    test "get/1 requests POST and returns Plaid.Auth", %{bypass: bypass} do
      body = http_response_body(:auth)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Auth.get(%{access_token: "my-token"})

      assert Plaid.Auth == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)

      body_account_number =
        body["numbers"]["ach"]
        |> Enum.at(0)
        |> Map.get("account")

      resp_acct_number = Enum.at(resp.numbers.ach, 0).account
      assert body_account_number == resp_acct_number
    end
  end
end
