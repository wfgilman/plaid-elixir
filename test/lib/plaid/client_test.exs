defmodule Plaid.ClientTest do
  use ExUnit.Case, async: true

  alias Plaid.Client.Request
  alias Plaid.Client

  @moduletag :client

  describe "client.request" do
    @describetag :unit

    test "to_options/1 converts struct to keyword list" do
      assert [
               method: :post,
               url: "some/endpoint",
               body: %{some: "body"},
               opts: [more: "options"]
             ] ==
               Request.to_options(%Request{
                 body: %{some: "body"},
                 endpoint: "some/endpoint",
                 method: :post,
                 opts: %{
                   more: "options"
                 }
               })
    end

    test "add_metadata/2 constructs instrumentation metadata" do
      request = %Request{body: %{}, endpoint: "some/endpoint", method: :post}

      assert %Request{
               opts: %{
                 metadata: %{
                   method: :post,
                   path: "some/endpoint",
                   u: :native
                 }
               }
             } = Request.add_metadata(request)
    end

    test "add_metadata/2 adds metadata passed in config argument" do
      request = %Request{body: %{}, endpoint: "some/endpoint", method: :post}
      config = %{telemetry_metadata: %{ins_id: "ins_1"}}

      assert %Request{
               opts: %{
                 metadata: %{
                   method: :post,
                   path: "some/endpoint",
                   u: :native,
                   ins_id: "ins_1"
                 }
               }
             } = Request.add_metadata(request, config)
    end
  end

  describe "client new/1" do
    @describetag :unit

    test "url is correctly set" do
      # raises with no url
      Application.put_env(:plaid, :root_uri, nil)

      assert_raise Plaid.MissingRootUriError, fn ->
        Client.new()
      end

      # uses app env
      Application.put_env(:plaid, :root_uri, "https://test-uri/")

      client = Client.new()

      assert Enum.member?(
               client.pre,
               {Tesla.Middleware.BaseUrl, :call, ["https://test-uri/"]}
             )

      # runtime config overrides app env
      client = Client.new(%{root_uri: "https://run-time-uri/"})

      assert Enum.member?(
               client.pre,
               {Tesla.Middleware.BaseUrl, :call, ["https://run-time-uri/"]}
             )
    end

    test "client_id is set in header correctly" do
      # raises with no client_id
      Application.put_env(:plaid, :client_id, nil)

      assert_raise Plaid.MissingClientIdError, fn ->
        Client.new()
      end

      # uses app env
      Application.put_env(:plaid, :client_id, "abcdefg")

      client = Client.new()

      assert Enum.find(client.pre, fn
               {Tesla.Middleware.Headers, _, [headers]} ->
                 Enum.member?(headers, {"PLAID-CLIENT-ID", "abcdefg"})

               _ ->
                 false
             end)

      # runtime config overrides app env
      client = Client.new(%{client_id: "my_runtime_client_id"})

      assert Enum.find(client.pre, fn
               {Tesla.Middleware.Headers, _, [headers]} ->
                 Enum.member?(headers, {"PLAID-CLIENT-ID", "my_runtime_client_id"})

               _ ->
                 false
             end)
    end

    test "secret is set in header correctly" do
      # raises with no secret
      Application.put_env(:plaid, :secret, nil)

      assert_raise Plaid.MissingSecretError, fn ->
        Client.new()
      end

      # uses app env
      Application.put_env(:plaid, :secret, "shhhhhh")

      client = Client.new()

      assert Enum.find(client.pre, fn
               {Tesla.Middleware.Headers, _, [headers]} ->
                 Enum.member?(headers, {"PLAID-SECRET", "shhhhhh"})

               _ ->
                 false
             end)

      # runtime config overrides app env
      client = Client.new(%{secret: "runtime-shhhhhh"})

      assert Enum.find(client.pre, fn
               {Tesla.Middleware.Headers, _, [headers]} ->
                 Enum.member?(headers, {"PLAID-SECRET", "runtime-shhhhhh"})

               _ ->
                 false
             end)
    end

    test "static headers are set correctly" do
      headers =
        Client.new(%{client_id: "test_client", secret: "test_secret"})
        |> Map.get(:pre)
        |> Enum.reduce(fn
          {Tesla.Middleware.Headers, _, [headers]}, _acc ->
            headers

          _, acc ->
            acc
        end)

      assert [
               {"Content-Type", "application/json"},
               {"user-agent", "Elixir-SDK"},
               {"Plaid-Version", "2020-09-14"},
               {"PLAID-CLIENT-ID", "test_client"},
               {"PLAID-SECRET", "test_secret"}
             ] == headers
    end

    test "JSON middleware is initialized" do
      client = Client.new()

      assert Enum.any?(client.pre, fn
               {Tesla.Middleware.JSON, _, _} ->
                 true

               _ ->
                 false
             end)
    end

    test "telemetry middleware is initialized" do
      client = Client.new()

      assert Enum.any?(client.pre, fn
               {Plaid.Telemetry, _, _} ->
                 true

               _ ->
                 false
             end)
    end

    test "adapter is set correctly" do
      # uses default
      client = Client.new()

      assert client.adapter == {Tesla.Adapter.Hackney, :call, [[]]}

      # reads from app env
      Application.put_env(:plaid, :adapter, Tesla.Adapter.Httpc)
      Application.put_env(:plaid, :http_options, recv_timeout: 12_345)

      client = Client.new()

      assert client.adapter == {Tesla.Adapter.Httpc, :call, [[recv_timeout: 12_345]]}

      # takes runtime configuration
      client = Client.new(%{adapter: Tesla.Adapter.Mint, http_options: [recv_timeout: 67_890]})

      assert client.adapter == {Tesla.Adapter.Mint, :call, [[recv_timeout: 67_890]]}

      # cleanup
      Application.delete_env(:plaid, :adapter)
      Application.delete_env(:plaid, :http_options)
    end
  end
end
