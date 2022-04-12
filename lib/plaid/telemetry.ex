defmodule Plaid.Telemetry do
  @moduledoc """
  Custom implementation of `telemetry` using Tesla Middleware.
  """

  @moduledoc deprecated: "Use Tesla.Middleware.Telemetry instead"

  @events_prefix [:plaid, :request]

  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  @deprecated "Use Tesla.Middleware.Telemetry instead"
  def call(env, next, _opts) do
    metadata = env.opts[:metadata] || %{}
    start_time = System.monotonic_time()

    :telemetry.execute(@events_prefix ++ [:start], %{system_time: start_time}, metadata)

    try do
      Tesla.run(env, next)
    rescue
      exception ->
        :telemetry.execute(
          @events_prefix ++ [:exception],
          %{duration: System.monotonic_time() - start_time},
          Map.put(metadata, :exception, exception)
        )

        reraise exception, __STACKTRACE__
    else
      {:ok, env} = result ->
        :telemetry.execute(
          @events_prefix ++ [:stop],
          %{duration: System.monotonic_time() - start_time},
          Map.merge(metadata, %{result: result, status: env.status})
        )

        result

      {:error, reason} = result ->
        :telemetry.execute(
          @events_prefix ++ [:stop],
          %{duration: System.monotonic_time() - start_time},
          Map.merge(metadata, %{result: result, reason: reason})
        )

        result
    end
  end
end
