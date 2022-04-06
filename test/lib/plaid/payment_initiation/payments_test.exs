defmodule Plaid.PaymentInitiation.PaymentsTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

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
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "payment_initiation/payment/create"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:"payment_initiation/payment/create")}
      end)

      assert {:ok, ds} = Plaid.PaymentInitiation.Payments.create(params, config)
      assert Plaid.PaymentInitiation.Payments.Payment == ds.__struct__
      assert ds.payment_id
      assert ds.status
      assert ds.request_id
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:"payment_initiation/payment/create")

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Payments.Payment{}} =
               Plaid.PaymentInitiation.Payments.create(params, config)
    end

    @tag :integration
    test "error integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Payments.create(params, config)
    end
  end

  describe "payment_initiation/payments get/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "payment_initiation/payment/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:"payment_initiation/payment/get")}
      end)

      assert {:ok, ds} = Plaid.PaymentInitiation.Payments.get(params, config)
      assert Plaid.PaymentInitiation.Payments.Payment == ds.__struct__
      assert Plaid.PaymentInitiation.Payments.Payment.Amount == ds.amount.__struct__
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:"payment_initiation/payment/get")

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Payments.Payment{}} =
               Plaid.PaymentInitiation.Payments.get(params, config)
    end

    @tag :integration
    test "error integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Payments.get(params, config)
    end
  end

  describe "payment_initiation/payments list/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "payment_initiation/payment/list"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:"payment_initiation/payment/list")}
      end)

      assert {:ok, ds} = Plaid.PaymentInitiation.Payments.list(params, config)
      assert Plaid.PaymentInitiation.Payments == ds.__struct__
      assert Plaid.PaymentInitiation.Payments.Payment == List.first(ds.payments).__struct__

      assert Plaid.PaymentInitiation.Payments.Payment.Amount ==
               List.first(ds.payments).amount.__struct__
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:"payment_initiation/payment/list")

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Payments{}} =
               Plaid.PaymentInitiation.Payments.list(params, config)
    end

    @tag :integration
    test "error integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Payments.list(params, config)
    end
  end
end
