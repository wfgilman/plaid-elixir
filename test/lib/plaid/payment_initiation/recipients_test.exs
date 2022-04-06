defmodule Plaid.PaymentInitiation.RecipientsTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

  setup do
    verify_on_exit!()

    {:ok,
     params: %{access_token: "my-token"},
     config: %{
       client: PlaidMock,
       client_id: "test_id",
       secret: "test_secret",
       root_uri: "http://localhost:4000/"
     }}
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
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "payment_initiation/recipient/create"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:"payment_initiation/recipient/create")}
      end)

      assert {:ok, ds} = Plaid.PaymentInitiation.Recipients.create(params, config)
      assert Plaid.PaymentInitiation.Recipients.Recipient == ds.__struct__
      assert ds.recipient_id
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

      body = http_response_body(:"payment_initiation/recipient/create")

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Recipients.Recipient{}} =
               Plaid.PaymentInitiation.Recipients.create(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Recipients.create(params, config)
    end
  end

  describe "payments_initiation/recipients get/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "payment_initiation/recipient/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:"payment_initiation/recipient/get")}
      end)

      assert {:ok, %Plaid.PaymentInitiation.Recipients.Recipient{}} =
               Plaid.PaymentInitiation.Recipients.get(params, config)
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:"payment_initiation/recipient/get")

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Recipients.Recipient{}} =
               Plaid.PaymentInitiation.Recipients.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Recipients.get(params, config)
    end
  end

  describe "payments_initiation/recipients list/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "payment_initiation/recipient/list"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:"payment_initiation/recipient/list")}
      end)

      assert {:ok, ds} = Plaid.PaymentInitiation.Recipients.list(config)
      assert Plaid.PaymentInitiation.Recipients == ds.__struct__
      assert Plaid.PaymentInitiation.Recipients.Recipient == List.first(ds.recipients).__struct__
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:"payment_initiation/recipient/list")

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.PaymentInitiation.Recipients{}} =
               Plaid.PaymentInitiation.Recipients.list(config)
    end

    @tag :integration
    test "error integration test" do
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

      assert {:error, %Plaid.Error{}} = Plaid.PaymentInitiation.Recipients.list(config)
    end
  end
end
