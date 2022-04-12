defmodule Plaid.TelemetryTest do
  use ExUnit.Case, async: true

  @moduletag :telemetry

  describe "plaid telemetry call/3" do
    setup do
      client =
        Tesla.client([Plaid.Telemetry], fn env ->
          case env.url do
            "/telemetry-success" ->
              {:ok, Map.put(env, :status, 200)}

            "/telemetry-error" ->
              {:error, :econnrefused}

            "/telemetry-exception" ->
              raise RuntimeError, "something went bad wrong"
          end
        end)

      options = [
        opts: [metadata: %{type: :cowabunga}]
      ]

      {:ok, %{client: client, options: options}}
    end

    test "emits start event", %{client: client, options: options} do
      :ok =
        :telemetry.attach(
          "emit-start-event",
          [:plaid, :request, :start],
          &__MODULE__.echo_event/4,
          %{caller: self()}
        )

      options = options ++ [url: "/telemetry-success"]

      Tesla.request(client, options)

      assert_receive {:event, [:plaid, :request, :start], %{system_time: _}, metadata}
      assert %{type: :cowabunga} == metadata

      :ok = :telemetry.detach("emit-start-event")
    end

    test "emits stop event for success response", %{client: client, options: options} do
      :ok =
        :telemetry.attach(
          "emit-stop-event",
          [:plaid, :request, :stop],
          &__MODULE__.echo_event/4,
          %{caller: self()}
        )

      options = options ++ [url: "/telemetry-success"]

      Tesla.request(client, options)

      assert_receive {:event, [:plaid, :request, :stop], %{duration: _}, metadata}
      assert %{status: 200, result: {:ok, %Tesla.Env{}}, type: :cowabunga} = metadata

      :ok = :telemetry.detach("emit-stop-event")
    end

    test "emits stop event for error response", %{client: client, options: options} do
      :ok =
        :telemetry.attach(
          "emit-stop-event",
          [:plaid, :request, :stop],
          &__MODULE__.echo_event/4,
          %{caller: self()}
        )

      options = options ++ [url: "/telemetry-error"]

      Tesla.request(client, options)

      assert_receive {:event, [:plaid, :request, :stop], %{duration: _}, metadata}

      assert %{result: {:error, :econnrefused}, reason: :econnrefused, type: :cowabunga} ==
               metadata

      :ok = :telemetry.detach("emit-stop-event")
    end

    test "emits stop event when exception is raised", %{client: client, options: options} do
      :ok =
        :telemetry.attach(
          "emit-exception-event",
          [:plaid, :request, :exception],
          &__MODULE__.echo_event/4,
          %{caller: self()}
        )

      options = options ++ [url: "/telemetry-exception"]

      assert_raise RuntimeError, fn ->
        Tesla.request(client, options)
      end

      assert_receive {:event, [:plaid, :request, :exception], %{duration: _}, metadata}

      assert %{
               exception: %RuntimeError{message: "something went bad wrong"},
               type: :cowabunga
             } == metadata

      :ok = :telemetry.detach("emit-exception-event")
    end
  end

  def echo_event(event, measurements, metadata, config) do
    send(config.caller, {:event, event, measurements, metadata})
  end
end
