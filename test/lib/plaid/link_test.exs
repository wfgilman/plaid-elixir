defmodule Plaid.LinkTest do
  use ExUnit.Case, async: true

  import Mox

  setup do
    verify_on_exit!()
    {:ok, params: %{access_token: "my-token"}, config: %{client: PlaidMock}}
  end

  @moduletag :link

  @tag :unit
  test "link data structure encodes with Jason" do
    assert {:ok, _} = Jason.encode(%Plaid.Link{metadata: %Plaid.Link.Metadata{}})
  end

  describe "link create_link_token/2" do
    @tag :unit
    test "makes post request to link/token/create endpoint", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "link/token/create"
        {:ok, %HTTPoison.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :link
        {:ok, %Plaid.Link{}}
      end)

      assert {:ok, %Plaid.Link{}} = Plaid.Link.create_link_token(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Link.create_link_token(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Link data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:create_link_token)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Link{}} = Plaid.Link.create_link_token(params, config)
    end

    @tag :integration
    test "returns Plaid.Error", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Link.create_link_token(params, config)
    end
  end

  describe "link get_link_token/2" do
    @tag :unit
    test "makes post request to link/token/get endpoint", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "link/token/get"
        {:ok, %HTTPoison.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :link
        {:ok, %Plaid.Link{}}
      end)

      assert {:ok, %Plaid.Link{}} = Plaid.Link.get_link_token(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Link.get_link_token(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Link data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:get_link_token)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Link{}} = Plaid.Link.get_link_token(params, config)
    end

    @tag :integration
    test "returns Plaid.Error", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.Link.get_link_token(params, config)
    end
  end
end
