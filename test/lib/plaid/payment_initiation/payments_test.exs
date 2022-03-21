defmodule Plaid.PaymentInitiation.PaymentsTest do
  use ExUnit.Case, async: true

  import Mox

  setup do
    verify_on_exit!()
    {:ok, params: %{access_token: "my-token"}, config: %{client: PlaidMock}}
  end

  @moduletag :"payment_initiation/payments"

  @tag :unit
  test "payment_initiation/payments data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.PaymentInitiation.Payments{
               payments: [
                 %Plaid.PaymentInitiation.Payments.Payment{
                   amount: %Plaid.PaymentInitiation.Payments.Payment.Amount{},
                   schedule: %Plaid.PaymentInitiation.Payments.Payment.Schedule{}
                 }
               ]
             })
  end

  describe "payment_initiation/payments create/2" do
    @tag :unit
    test "makes post request to payment_initiation/payments/create endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "payment_initiation/payment/create"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :"payment_initiation/payment"
        {:ok, %Plaid.PaymentInitiation.Payments.Payment{}}
      end)

      assert {:ok, %Plaid.PaymentInitiation.Payments.Payment{}} =
               Plaid.PaymentInitiation.Payments.create(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.PaymentInitiation.Payments.create(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.PaymentInitiation.Payments.Payment data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:"payment_initiation/payment/create")

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Payments.Payment{}} =
               Plaid.PaymentInitiation.Payments.create(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Payments.create(params, config)
    end
  end

  describe "payment_initiation/payments get/2" do
    @tag :unit
    test "makes post request to payments_initiation/payments/get endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "payment_initiation/payment/get"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :"payment_initiation/payment"
        {:ok, %Plaid.PaymentInitiation.Payments.Payment{}}
      end)

      assert {:ok, %Plaid.PaymentInitiation.Payments.Payment{}} =
               Plaid.PaymentInitiation.Payments.get(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.PaymentInitiation.Payments.get(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.PaymentInitiation.Payments.Payment data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:"payment_initiation/payment/get")

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Payments.Payment{}} =
               Plaid.PaymentInitiation.Payments.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Payments.get(params, config)
    end
  end

  describe "payment_initiation/payments list/2" do
    @tag :unit
    test "makes post request to payments_initiation/payments/list endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "payment_initiation/payment/list"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :"payment_initiation/payment"
        {:ok, %Plaid.PaymentInitiation.Payments{}}
      end)

      assert {:ok, %Plaid.PaymentInitiation.Payments{}} =
               Plaid.PaymentInitiation.Payments.list(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.PaymentInitiation.Payments.list(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.PaymentInitiation.Payments data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:"payment_initiation/payment/list")

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Payments{}} =
               Plaid.PaymentInitiation.Payments.list(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Payments.list(params, config)
    end
  end
end
