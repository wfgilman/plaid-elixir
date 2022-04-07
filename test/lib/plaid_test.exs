defmodule PlaidTest do
  use ExUnit.Case, async: true

  alias Plaid.Client
  alias Plaid.Client.Request

  @moduletag :plaid

  defmodule Result, do: defstruct([:some])

  describe "plaid send_request/2" do
    setup do
      bypass = Bypass.open()
      Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")

      config = %{
        client_id: "my-client",
        secret: "my-secret"
      }

      client = Client.new(config)
      request = %Request{method: :post, endpoint: "some/endpoint", body: %{some: "body"}}

      {:ok, bypass: bypass, client: client, request: request}
    end

    @describetag :integration

    test "passes request parameters to Tesla client correctly", %{
      bypass: bypass,
      client: client,
      request: request
    } do
      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        {:ok, body, _conn} = Plug.Conn.read_body(conn)
        assert "{\"some\":\"body\"}" == body
        assert "localhost" == conn.host
        assert "/some/endpoint" == conn.request_path

        assert [
                 {"content-type", "application/json"},
                 {"plaid-client-id", "my-client"},
                 {"plaid-secret", "my-secret"},
                 {"plaid-version", "2020-09-14"},
                 {"user-agent", "Elixir-SDK"}
               ] ==
                 Enum.filter(conn.req_headers, fn {k, _v} ->
                   k in [
                     "content-type",
                     "plaid-client-id",
                     "plaid-secret",
                     "plaid-version",
                     "user-agent"
                   ]
                 end)

        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      Plaid.send_request(request, client)
    end

    test "returns correct values", %{bypass: bypass, client: client, request: request} do
      # successful request
      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, "{\"status\":\"ok\"}")
      end)

      assert {:ok, %Tesla.Env{status: 200} = env} = Plaid.send_request(request, client)
      assert is_map(env.body)

      # failed request
      Bypass.down(bypass)

      assert {:error, :econnrefused} = Plaid.send_request(request, client)
    end

    test "emits telemetry events", %{bypass: bypass, client: client, request: request} do
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
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      r = Request.add_metadata(request, %{telemetry_metadata: %{type: :cowabunga}})

      Plaid.send_request(r, client)

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

    test "emits telemetry event during http failure", %{
      bypass: bypass,
      client: client,
      request: request
    } do
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

      r = Request.add_metadata(request)

      Plaid.send_request(r, client)

      assert_receive {:event, [:plaid, :request, :start], %{system_time: _}, metadata}

      assert %{
               method: :post,
               path: "some/endpoint",
               u: :native
             } == metadata

      assert_receive {:event, [:plaid, :request, :stop], %{duration: _}, metadata}

      assert %{
               result: {:error, :econnrefused},
               reason: :econnrefused,
               method: :post,
               path: "some/endpoint",
               u: :native
             } = metadata

      :ok = :telemetry.detach("error-handler")
    end

    test "telemetry measures duration of http request", %{request: request} do
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

      client1 = Client.new(config1)

      bypass2 = Bypass.open()

      config2 = %{
        root_uri: "http://localhost:#{bypass2.port}/",
        telemetry_metadata: %{call: :delayed}
      }

      client2 = Client.new(config2)

      Bypass.expect(bypass1, fn conn ->
        # Instant response
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      Bypass.expect(bypass2, fn conn ->
        # Delayed response
        :timer.sleep(800)
        Plug.Conn.resp(conn, 200, "{\"status\":\"ok\"}")
      end)

      Plaid.send_request(Request.add_metadata(request, config1), client1)
      Plaid.send_request(Request.add_metadata(request, config2), client2)

      assert_receive {:event, [:plaid, :request, :stop], %{duration: duration1},
                      %{call: :instant}}

      assert_receive {:event, [:plaid, :request, :stop], %{duration: duration2},
                      %{call: :delayed}}

      # Check to see if duration reflects delay
      refute_in_delta(
        System.convert_time_unit(duration1, :native, :millisecond),
        System.convert_time_unit(duration2, :native, :millisecond),
        500
      )

      :ok = :telemetry.detach("duration-measurement-handler")
    end
  end

  describe "plaid handle_response/2" do
    @describetag :unit

    test "returns {:ok, body} and applies mapper fun for http response 200-299" do
      env = %Tesla.Env{
        status: 200,
        body: %{some: "body"}
      }

      mapper = fn body -> struct(Result, Map.to_list(body)) end

      assert {:ok, %Result{some: "body"}} == Plaid.handle_response({:ok, env}, mapper)
    end

    test "returns {:error, Plaid.Error.t} for response >=300" do
      env = %Tesla.Env{
        status: 400,
        body: Plaid.Factory.http_response_body(:error)
      }

      mapper = fn body -> body end

      assert {:error, %Plaid.Error{}} = Plaid.handle_response({:ok, env}, mapper)
    end

    test "returns http failure" do
      mapper = fn body -> body end

      assert {:error, :econnrefused} = Plaid.handle_response({:error, :econnrefused}, mapper)
    end
  end

  def echo_event(event, measurements, metadata, config) do
    send(config.caller, {:event, event, measurements, metadata})
  end
end
