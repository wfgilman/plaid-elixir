defmodule PlaidTelemetryTest do
  use ExUnit.Case, async: false

  @moduletag :plaid_telemetry

  # Asserting results in the event handler isn't ideal because failures don't print nicely,
  # but the test pattern is more readable than sending messages.
  describe "plaid_telemetry instrument/2" do
    setup do
      Logger.configure(level: :warn)
    end

    @describetag :unit

    test "sends start event" do
      :ok =
        :telemetry.attach(
          "send-start-event",
          [:plaid, :request, :start],
          fn name, measurements, metadata, _config ->
            assert name == [:plaid, :request, :start]
            assert measurements[:system_time]
            assert %{type: :cowabunga} == metadata
          end,
          nil
        )

      PlaidTelemetry.instrument(fn -> fun(:success) end, %{type: :cowabunga})

      :telemetry.detach("send-start-event")
    end

    test "sends stop event for success response" do
      :ok =
        :telemetry.attach(
          "send-stop-event",
          [:plaid, :request, :stop],
          fn name, measurements, metadata, _config ->
            assert name == [:plaid, :request, :stop]
            assert measurements[:duration]
            assert {:ok, %HTTPoison.Response{}} = metadata[:result]
            assert metadata[:status] == 200
            assert metadata[:type] == :cowabunga
          end,
          nil
        )

      PlaidTelemetry.instrument(fn -> fun(:success) end, %{type: :cowabunga})

      :telemetry.detach("send-stop-event")
    end

    test "sends stop event for error response" do
      :ok =
        :telemetry.attach(
          "send-stop-event",
          [:plaid, :request, :stop],
          fn name, measurements, metadata, _config ->
            assert name == [:plaid, :request, :stop]
            assert measurements[:duration]
            assert {:error, %HTTPoison.Error{}} = metadata[:result]
            assert metadata[:type] == :cowabunga
          end,
          nil
        )

      PlaidTelemetry.instrument(fn -> fun(:error) end, %{type: :cowabunga})

      :telemetry.detach("send-stop-event")
    end

    test "send event when exception is raised" do
      :ok =
        :telemetry.attach(
          "send-exception-event",
          [:plaid, :request, :exception],
          fn name, measurements, metadata, _config ->
            assert name == [:plaid, :request, :exception]
            assert measurements[:duration]
            assert metadata[:exception]
            assert metadata[:type] == :cowabunga
          end,
          nil
        )

      assert_raise RuntimeError, fn ->
        PlaidTelemetry.instrument(fn -> fun(:exception) end, %{type: :cowabunga})
      end

      :telemetry.detach("send-exception-event")
    end
  end

  defp fun(result) do
    case result do
      :success ->
        {:ok, %HTTPoison.Response{status_code: 200}}

      :error ->
        {:error, %HTTPoison.Error{}}

      :exception ->
        raise RuntimeError
    end
  end
end
