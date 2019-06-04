defmodule PlaidTest do
  use ExUnit.Case

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "plaid" do
    test "get_cred/0 returns credentials as a map" do
      assert %{client_id: _, secret: _} = Plaid.get_cred()
    end

    test "get_cred/0 raises when client_id is missing" do
      Application.put_env(:plaid, :client_id, nil)
      assert_raise Plaid.MissingClientIdError, fn -> Plaid.get_cred() end
      cleanup_config()
    end

    test "get_cred/0 raises when secret is missing" do
      Application.put_env(:plaid, :secret, nil)
      assert_raise Plaid.MissingSecretError, fn -> Plaid.get_cred() end
      cleanup_config()
    end

    test "get_key/0 raises when public_key is missing" do
      Application.put_env(:plaid, :public_key, nil)
      assert_raise Plaid.MissingPublicKeyError, fn -> Plaid.get_key() end
      cleanup_config()
    end
    
    test "validate_cred/1 returns credentials from config" do
      config = %{client_id: "me", secret: "shhhh", public_key: "yoyo"}

      assert %{
               client_id: "me",
               secret: "shhhh"
             } == Plaid.validate_cred(config)
    end

    test "validate_cred/1 uses configuration value when no config is passed as argument" do
      Application.put_env(:plaid, :client_id, "you")
      Application.put_env(:plaid, :secret, "no secrets")

      assert %{
               client_id: "you",
               secret: "no secrets"
             } == Plaid.validate_cred(%{})
    end

    test "validate_cred/1 raises ClientIdError when client_id is missing from config argument and app configuration" do
      Application.put_env(:plaid, :client_id, nil)
      assert_raise Plaid.MissingClientIdError, fn -> Plaid.validate_cred(%{secret: "shhh"}) end
      cleanup_config()
    end

    test "validate_cred/1 raises SecretError when secret is missing from config argument and app configuration" do
      Application.put_env(:plaid, :secret, nil)
      assert_raise Plaid.MissingSecretError, fn -> Plaid.validate_cred(%{client_id: "me"}) end
      cleanup_config()
    end

    test "validate_public_key/1 uses configuration value when no config is passed as argument" do
      Application.put_env(:plaid, :public_key, "yoyoyo")

      assert %{
               public_key: "yoyoyo"
             } == Plaid.validate_public_key(%{})
    end

    test "validate_public_key/1 raises when public_key is missing from config argument and app configuration" do
      Application.put_env(:plaid, :public_key, nil)
      assert_raise Plaid.MissingPublicKeyError, fn -> Plaid.validate_public_key(%{}) end
      cleanup_config()
    end

    test "make_request/2 requests GET returns HTTPoison.Response", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        assert "GET" == conn.method
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      {:ok, resp} = Plaid.make_request(:get, "any")

      assert HTTPoison.Response == resp.__struct__
    end

    test "make_request/2 returns HTTPoison.Error when HTTP call fails", %{bypass: bypass} do
      Bypass.down(bypass)

      assert {:error, %HTTPoison.Error{}} = Plaid.make_request(:get, "any")
    end

    test "make_request_with_cred/3 merges credentials into request body", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        {:ok, body, _conn} = Plug.Conn.read_body(conn)
        assert "POST" == conn.method
        assert "{\"secret\":\"shhhh\",\"client_id\":\"id\"}" == body
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      Plaid.make_request_with_cred(:post, "any", %{client_id: "id", secret: "shhhh"})
    end

    test "make_request_with_cred/3 uses root_uri in configuration if not passed in config", %{
      bypass: bypass
    } do
      Bypass.expect(bypass, fn conn ->
        assert "localhost" == conn.host
        assert "/any" == conn.request_path
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      Plaid.make_request_with_cred(:post, "any", %{})
    end

    test "make_request_with_cred/3 uses root_uri value if provided in config argument", %{
      bypass: bypass
    } do
      Bypass.expect(bypass, fn conn ->
        assert "0.0.0.0" == conn.host
        assert "/any" == conn.request_path
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      Plaid.make_request_with_cred(:post, "any", %{root_uri: "http://0.0.0.0:#{bypass.port}/"})
    end

    test "make_request/2 sets headers correctly", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        content_type =
          Enum.find(conn.req_headers, fn {k, _v} ->
            k == "content-type"
          end)

        assert {"content-type", "application/json"} == content_type
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      Plaid.make_request(:get, "any")
    end
  end

  defp cleanup_config do
    Application.put_env(:plaid, :client_id, "test_id")
    Application.put_env(:plaid, :secret, "test_secret")
    Application.put_env(:plaid, :public_key, "s3cret")
  end
end
