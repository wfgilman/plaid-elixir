defmodule PlaidTelemetry do
  @events_prefix [:plaid, :request]

  @callback instrument(function, map) :: term
  def instrument(fun, metadata) when is_function(fun) do
    start_time = System.monotonic_time()

    :telemetry.execute(@events_prefix ++ [:start], %{system_time: start_time}, metadata)

    try do
      fun.()
    rescue
      exception ->
        :telemetry.execute(
          @events_prefix ++ [:exception],
          %{duration: System.monotonic_time() - start_time},
          Map.put(metadata, :exception, exception)
        )

        reraise exception, __STACKTRACE__
    else
      # This handler is tightly coupled with the PlaidHTTP behaviour.
      {:ok, response} = result ->
        :telemetry.execute(
          @events_prefix ++ [:stop],
          %{duration: System.monotonic_time() - start_time},
          Map.merge(metadata, %{result: result, status: response.status_code})
        )

        result

      {:error, _reason} = result ->
        :telemetry.execute(
          @events_prefix ++ [:stop],
          %{duration: System.monotonic_time() - start_time},
          Map.put(metadata, :result, result)
        )

        result
    end
  end
end
