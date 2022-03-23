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
      expect(Plaid.HTTPClientMock, :call, fn _method,
                                             _url,
                                             body,
                                             _headers,
                                             _http_options,
                                             _metadata ->
        assert body[:client_id]
        assert body[:secret]
        refute body[:root_uri]
        {:ok, %Plaid.HTTPClient.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "https://test-uri",
        http_client: Plaid.HTTPClientMock
      })
    end

    test "constructs full url from endpoint" do
      expect(Plaid.HTTPClientMock, :call, fn _method,
                                             url,
                                             _body,
                                             _headers,
                                             _http_options,
                                             _metadata ->
        assert url == "https://test-uri/some/endpoint"
        {:ok, %Plaid.HTTPClient.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{
        root_uri: "https://test-uri/",
        http_client: Plaid.HTTPClientMock
      })
    end

    test "raises when root_uri when application not configured and not supplied in runtime config" do
      Application.put_env(:plaid, :root_uri, nil)

      assert_raise Plaid.MissingRootUriError, fn ->
        Plaid.make_request(:post, "some/endpoint", %{}, %{http_client: Plaid.HTTPClientMock})
      end
    end

    test "runtime config overrides root_uri value in application configuration" do
      expect(Plaid.HTTPClientMock, :call, fn _method,
                                             url,
                                             _body,
                                             _headers,
                                             _http_options,
                                             _metadata ->
        assert url == "https://test-uri/some/endpoint"
        {:ok, %Plaid.HTTPClient.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{
        root_uri: "https://test-uri/",
        http_client: Plaid.HTTPClientMock
      })
    end

    test "constructs headers" do
      expect(Plaid.HTTPClientMock, :call, fn _method,
                                             _url,
                                             _body,
                                             headers,
                                             _http_options,
                                             _metadata ->
        assert headers == [{"Content-Type", "application/json"}]
        {:ok, %Plaid.HTTPClient.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{http_client: Plaid.HTTPClientMock})
    end

    test "takes Plaid.HTTPClient options from application configuration" do
      Application.put_env(:plaid, :http_options, recv_timeout: 1_234)

      expect(Plaid.HTTPClientMock, :call, fn _method,
                                             _url,
                                             _body,
                                             _headers,
                                             http_options,
                                             _metadata ->
        assert http_options[:recv_timeout] == 1_234
        {:ok, %Plaid.HTTPClient.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{http_client: Plaid.HTTPClientMock})
    end

    test "runtime Plaid.HTTPClient options override application configuration" do
      Application.put_env(:plaid, :http_options, recv_timeout: 1_234)

      expect(Plaid.HTTPClientMock, :call, fn _method,
                                             _url,
                                             _body,
                                             _headers,
                                             http_options,
                                             _metadata ->
        assert http_options[:recv_timeout] == 5_678
        assert http_options[:ssl] == [certfile: "certs/client.crt"]
        {:ok, %Plaid.HTTPClient.Response{}}
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{
        http_options: [recv_timeout: 5_678, ssl: [certfile: "certs/client.crt"]],
        http_client: Plaid.HTTPClientMock
      })
    end

    test "constructs default instrumentation metadata" do
      expect(Plaid.HTTPClientMock, :call, fn _method,
                                             _url,
                                             _body,
                                             _headers,
                                             _http_options,
                                             metadata ->
        assert %{
                 method: :post,
                 path: "some/endpoint",
                 u: :native
               } == metadata
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{http_client: Plaid.HTTPClientMock})
    end

    test "adds instrumentation metadata passed via runtime config argument" do
      expect(Plaid.HTTPClientMock, :call, fn _method,
                                             _url,
                                             _body,
                                             _headers,
                                             _http_options,
                                             metadata ->
        assert %{
                 method: :post,
                 path: "some/endpoint",
                 u: :native,
                 ins_id: "ins_1"
               } == metadata
      end)

      Plaid.make_request(:post, "some/endpoint", %{}, %{
        http_client: Plaid.HTTPClientMock,
        telemetry_metadata: %{ins_id: "ins_1"}
      })
    end
  end

  describe "plaid make_request/4 integration test" do
    setup do
      bypass = Bypass.open()
      Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
      {:ok, bypass: bypass}
    end

    @describetag :integration

    test "passes parameters, returns Plaid.HTTPClient.Response, and emits telemetry events", %{
      bypass: bypass
    } do
      :ok =
        :telemetry.attach_many(
          "success-handler",
          [
            [:plaid, :request, :start],
            [:plaid, :request, :stop]
          ],
          &__MODULE__.echo_event/4,
          %{caller: self()}
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

      assert {:ok, %Plaid.HTTPClient.Response{}} =
               Plaid.make_request(:post, "some/endpoint", %{secret: "shhhh"}, %{
                 telemetry_metadata: %{type: :cowabunga}
               })

      assert_receive {:event, [:plaid, :request, :start], %{system_time: _}, metadata}

      assert %{
               method: :post,
               path: "some/endpoint",
               u: :native,
               type: :cowabunga
             } == metadata

      assert_receive {:event, [:plaid, :request, :stop], %{duration: _}, metadata}

      assert %{
               status: 200,
               result: {:ok, %Tesla.Env{}},
               method: :post,
               path: "some/endpoint",
               u: :native,
               type: :cowabunga
             } = metadata

      :ok = :telemetry.detach("success-handler")
    end

    test "Plaid.Telemetry measures the duration of the HTTP call" do
      :ok =
        :telemetry.attach(
          "duration-measurement-handler",
          [:plaid, :request, :stop],
          &__MODULE__.echo_event/4,
          %{caller: self()}
        )

      bypass1 = Bypass.open()

      config1 = %{
        root_uri: "http://localhost:#{bypass1.port}/",
        telemetry_metadata: %{call: :instant}
      }

      bypass2 = Bypass.open()

      config2 = %{
        root_uri: "http://localhost:#{bypass2.port}/",
        telemetry_metadata: %{call: :delayed}
      }

      Bypass.expect(bypass1, fn conn ->
        # Instant response
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      Bypass.expect(bypass2, fn conn ->
        # Delayed response
        :timer.sleep(500)
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      Plaid.make_request(:post, "some/endpoint", %{some: "body"}, config1)
      Plaid.make_request(:post, "some/endpoint", %{some: "body"}, config2)

      assert_receive {:event, [:plaid, :request, :stop], %{duration: duration1},
                      %{call: :instant}}

      assert_receive {:event, [:plaid, :request, :stop], %{duration: duration2},
                      %{call: :delayed}}

      refute_in_delta(
        System.convert_time_unit(duration1, :native, :millisecond),
        System.convert_time_unit(duration2, :native, :millisecond),
        200
      )

      :ok = :telemetry.detach("duration-measurement-handler")
    end

    test "returns Plaid.HTTPClient.Response with status_code > 201", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 400, "{\"status\":\"ok\"}")
      end)

      assert {:ok, %Plaid.HTTPClient.Response{}} = Plaid.make_request(:post, "some/endpoint", %{})
    end

    test "return Plaid.HTTPClient.Error and emit telemetry events", %{bypass: bypass} do
      :ok =
        :telemetry.attach_many(
          "error-handler",
          [
            [:plaid, :request, :start],
            [:plaid, :request, :stop]
          ],
          &__MODULE__.echo_event/4,
          %{caller: self()}
        )

      Bypass.down(bypass)

      assert {:error, %Plaid.HTTPClient.Error{}} =
               Plaid.make_request(:post, "another/endpoint", %{})

      assert_receive {:event, [:plaid, :request, :start], %{system_time: _}, metadata}

      assert %{
               method: :post,
               path: "another/endpoint",
               u: :native
             } == metadata

      assert_receive {:event, [:plaid, :request, :stop], %{duration: _}, metadata}

      assert %{
               result: {:error, :econnrefused},
               reason: :econnrefused,
               method: :post,
               path: "another/endpoint",
               u: :native
             } = metadata

      :ok = :telemetry.detach("error-handler")
    end
  end

  def echo_event(event, measurements, metadata, config) do
    send(config.caller, {:event, event, measurements, metadata})
  end
end
