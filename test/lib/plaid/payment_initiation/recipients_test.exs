defmodule Plaid.PaymentInitiation.RecipientsTest do
  use ExUnit.Case, async: true

  import Mox

  setup do
    verify_on_exit!()
    {:ok, params: %{access_token: "my-token"}, config: %{client: PlaidMock}}
  end

  @moduletag :"payment_initiation/recipients"

  @tag :unit
  test "payment_initiation/recipients data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.PaymentInitiation.Recipients{
               recipients: [
                 %Plaid.PaymentInitiation.Recipients.Recipient{
                   address: %Plaid.PaymentInitiation.Recipients.Recipient.Address{}
                 }
               ]
             })
  end

  describe "payments_initiation/recipients create/2" do
    @tag :unit
    test "makes post request to payments_initiation/recipients/create endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "payment_initiation/recipient/create"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :"payment_initiation/recipient"
        {:ok, %Plaid.PaymentInitiation.Recipients.Recipient{}}
      end)

      assert {:ok, %Plaid.PaymentInitiation.Recipients.Recipient{}} =
               Plaid.PaymentInitiation.Recipients.create(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.PaymentInitiation.Recipients.create(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.PaymentInitiation.Recipients.Recipient data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:"payment_initiation/recipient/create")

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Recipients.Recipient{}} =
               Plaid.PaymentInitiation.Recipients.create(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Recipients.create(params, config)
    end
  end

  describe "payments_initiation/recipients get/2" do
    @tag :unit
    test "makes post request to payments_initiation/recipients/get endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "payment_initiation/recipient/get"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :"payment_initiation/recipient"
        {:ok, %Plaid.PaymentInitiation.Recipients.Recipient{}}
      end)

      assert {:ok, %Plaid.PaymentInitiation.Recipients.Recipient{}} =
               Plaid.PaymentInitiation.Recipients.get(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.PaymentInitiation.Recipients.get(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.PaymentInitiation.Recipients.Recipient data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:"payment_initiation/recipient/get")

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Recipients.Recipient{}} =
               Plaid.PaymentInitiation.Recipients.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Recipients.get(params, config)
    end
  end

  describe "payments_initiation/recipients list/2" do
    @tag :unit
    test "makes post request to payments_initiation/recipients/list endpoint", %{config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "payment_initiation/recipient/list"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :"payment_initiation/recipient"
        {:ok, %Plaid.PaymentInitiation.Recipients{}}
      end)

      assert {:ok, %Plaid.PaymentInitiation.Recipients{}} =
               Plaid.PaymentInitiation.Recipients.list(config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.PaymentInitiation.Recipients.list(config)
      end
    end

    @tag :integration
    test "returns Plaid.PaymentInitiation.Recipients data structure" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:"payment_initiation/recipient/list")

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Recipients{}} =
               Plaid.PaymentInitiation.Recipients.list(config)
    end

    @tag :integration
    test "returns Plaid.Error" do
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

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Recipients.list(config)
    end
  end
end
