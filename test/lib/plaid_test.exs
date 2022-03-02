defmodule PlaidTest do
  use ExUnit.Case, async: true

  import Mox

  @moduletag :plaid

  describe "plaid valid_credentials?/1" do
    @describetag :unit

    test "returns true when application is configured" do
      Application.put_env(:plaid, :client_id, "test_id")
      Application.put_env(:plaid, :secret, "test_secret")

      assert Plaid.valid_credentials?(%{})
    end

    test "returns true when application not configured but credentials passed in config" do
      Application.put_env(:plaid, :client_id, nil)
      Application.put_env(:plaid, :secret, nil)

      assert Plaid.valid_credentials?(%{client_id: "test_id", secret: "test_secret"})
    end

    test "raises when application not configured and credentials not supplied" do
      Application.put_env(:plaid, :client_id, nil)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.valid_credentials?(%{secret: "shhh"})
      end

      Application.put_env(:plaid, :secret, nil)

      assert_raise Plaid.MissingSecretError, fn ->
        Plaid.valid_credentials?(%{client_id: "test_id"})
      end
    end
  end

  describe "plaid make_request/4" do
    setup do
      verify_on_exit!()
      Application.put_env(:plaid, :root_uri, "https://config-uri/")
      :ok
    end

    @describetag :unit

    test "adds only client_id and secret to request body" do
      expect(PlaidHTTPMock, :call, fn _method, _url, body, _headers, _options ->
        assert body[:client_id]
        assert body[:secret]
        refute body[:root_uri]
        {:ok, %HTTPoison.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "https://test-uri",
        http_client: PlaidHTTPMock
      })
    end

    test "constructs full url from endpoint" do
      expect(PlaidHTTPMock, :call, fn _method, url, _body, _headers, _options ->
        assert url == "https://test-uri/some/endpoint"
        {:ok, %HTTPoison.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{
        root_uri: "https://test-uri/",
        http_client: PlaidHTTPMock
      })
    end

    test "raises when root_uri when application not configured and not supplied in runtime config" do
      Application.put_env(:plaid, :root_uri, nil)

      assert_raise Plaid.MissingRootUriError, fn ->
        Plaid.make_request(:post, "some/endpoint", %{}, %{http_client: PlaidHTTPMock})
      end
    end

    test "runtime config overrides root_uri value in application configuration" do
      expect(PlaidHTTPMock, :call, fn _method, url, _body, _headers, _options ->
        assert url == "https://test-uri/some/endpoint"
        {:ok, %HTTPoison.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{
        root_uri: "https://test-uri/",
        http_client: PlaidHTTPMock
      })
    end

    test "constructs headers" do
      expect(PlaidHTTPMock, :call, fn _method, _url, _body, headers, _options ->
        assert headers == [{"Content-Type", "application/json"}]
        {:ok, %HTTPoison.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{http_client: PlaidHTTPMock})
    end

    test "takes HTTPoison options from application configuration" do
      Application.put_env(:plaid, :httpoison_options, recv_timeout: 1_234)

      expect(PlaidHTTPMock, :call, fn _method, _url, _body, _headers, options ->
        assert options[:recv_timeout] == 1_234
        {:ok, %HTTPoison.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{http_client: PlaidHTTPMock})
    end

    test "runtime HTTPoison options override application configuration" do
      Application.put_env(:plaid, :httpoison_options, recv_timeout: 1_234)

      expect(PlaidHTTPMock, :call, fn _method, _url, _body, _headers, options ->
        assert options[:recv_timeout] == 5_678
        assert options[:ssl] == [certfile: "certs/client.crt"]
        {:ok, %HTTPoison.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{
        httpoison_options: [recv_timeout: 5_678, ssl: [certfile: "certs/client.crt"]],
        http_client: PlaidHTTPMock
      })
    end

    test "constructs default instrumentation metadata" do
      expect(PlaidTelemetryMock, :instrument, fn _fun, metadata ->
        assert %{
                 method: :post,
                 path: "some/endpoint",
                 u: :native
               } == metadata
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{telemetry: PlaidTelemetryMock})
    end

    test "adds instrumentation metadata passed via runtime config argument" do
      expect(PlaidTelemetryMock, :instrument, fn _fun, metadata ->
        assert %{
                 method: :post,
                 path: "some/endpoint",
                 u: :native,
                 ins_id: "ins_1"
               } == metadata
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{
        telemetry: PlaidTelemetryMock,
        telemetry_metadata: %{ins_id: "ins_1"}
      })
    end
  end

  describe "plaid make_request/4 integration test" do
    setup do
      Logger.configure(level: :warn)
      bypass = Bypass.open()
      Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
      {:ok, bypass: bypass}
    end

    @describetag :integration

    test "passes parameters, returns HTTPoison.Response, and emits telemetry events", %{
      bypass: bypass
    } do
      :ok =
        :telemetry.attach_many(
          "success-handler",
          [
            [:plaid, :request, :start],
            [:plaid, :request, :stop]
          ],
          fn
            [:plaid, :request, :start], measurements, _metadata, _config ->
              assert measurements[:system_time]

            [:plaid, :request, :stop], measurements, metadata, _config ->
              assert measurements[:duration]
              assert {:ok, %HTTPoison.Response{}} = metadata[:result]
              assert metadata[:status] == 200
          end,
          nil
        )

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        {:ok, body, _conn} = Plug.Conn.read_body(conn)
        assert "{\"secret\":\"shhhh\"}" == body
        assert "localhost" == conn.host
        assert "/some/endpoint" == conn.request_path
        content_type = Enum.find(conn.req_headers, fn {k, _v} -> k == "content-type" end)
        assert {"content-type", "application/json"} == content_type
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      assert {:ok, %HTTPoison.Response{}} =
               Plaid.make_request(:post, "some/endpoint", %{secret: "shhhh"})

      :telemetry.detach("success-handler")
    end

    test "returns HTTPoison.Response with status_code > 201", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 400, "{\"status\":\"ok\"}")
      end)

      assert {:ok, %HTTPoison.Response{}} = Plaid.make_request(:post, "some/endpoint", %{})
    end

    test "return HTTPoison.Error and emit telemetry events", %{bypass: bypass} do
      :ok =
        :telemetry.attach_many(
          "error-handler",
          [
            [:plaid, :request, :start],
            [:plaid, :request, :stop]
          ],
          fn
            [:plaid, :request, :start], measurements, _metadata, _config ->
              assert measurements[:system_time]

            [:plaid, :request, :stop], measurements, metadata, _config ->
              assert measurements[:duration]
              assert {:error, %HTTPoison.Error{}} = metadata[:result]
          end,
          nil
        )

      Bypass.down(bypass)

      assert {:error, %HTTPoison.Error{}} = Plaid.make_request(:post, "some/endpoint", %{})

      :telemetry.detach("error-handler")
    end
  end
end
