defmodule Plaid.ItemTest do
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

  @moduletag :item

  @tag :unit
  test "item data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.Item{
               status: %Plaid.Item.Status{
                 investments: %Plaid.Item.Status.Investments{},
                 transactions: %Plaid.Item.Status.Transactions{},
                 last_webhook: %Plaid.Item.Status.LastWebhook{}
               }
             })
  end

  describe "item get/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "item/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:item)
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.Item.get(params, config)
      assert Plaid.Item == ds.__struct__
      assert Plaid.Item.Status == ds.status.__struct__
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

      body = http_response_body(:item)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Item{}} = Plaid.Item.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Item.get(params, config)
    end
  end

  describe "item exchange_public_token/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "item/public_token/exchange"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:exchange_public_token)
        {:ok, mapper.(body)}
      end)

      assert {:ok, r} = Plaid.Item.exchange_public_token(params, config)
      assert r.access_token
      assert r.request_id
      assert r.item_id
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:exchange_public_token)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %{access_token: _, request_id: _, item_id: _}} =
               Plaid.Item.exchange_public_token(params, config)
    end
  end

  describe "item create_public_token/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "item/public_token/create"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:create_public_token)
        {:ok, mapper.(body)}
      end)

      assert {:ok, r} = Plaid.Item.create_public_token(params, config)
      assert r.public_token
      assert r.expiration
      assert r.request_id
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:create_public_token)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %{public_token: _, expiration: _, request_id: _}} =
               Plaid.Item.create_public_token(params, config)
    end
  end

  describe "item update_webhook/2" do
    @tag :unit
    test "sends request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "item/webhook/update"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:webhook)
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.Item.update_webhook(params, config)
      assert Plaid.Item == ds.__struct__
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

      body = http_response_body(:webhook)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Item{}} = Plaid.Item.update_webhook(params, config)
    end
  end

  describe "item rotate_access_token/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "item/access_token/invalidate"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:rotate_access_token)
        {:ok, mapper.(body)}
      end)

      assert {:ok, r} = Plaid.Item.rotate_access_token(params, config)
      assert r.new_access_token
      assert r.request_id
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:rotate_access_token)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %{new_access_token: _, request_id: _}} =
               Plaid.Item.rotate_access_token(params, config)
    end
  end

  describe "item update_version_access_token/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "item/access_token/update_version"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:update_version_access_token)
        {:ok, mapper.(body)}
      end)

      assert {:ok, r} = Plaid.Item.update_version_access_token(params, config)
      assert r.access_token
      assert r.request_id
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:update_version_access_token)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %{access_token: _, request_id: _}} =
               Plaid.Item.update_version_access_token(params, config)
    end
  end

  describe "item remove/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "item/remove"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:remove)
        {:ok, mapper.(body)}
      end)

      assert {:ok, r} = Plaid.Item.remove(params, config)
      assert r.request_id
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:remove)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %{request_id: _}} = Plaid.Item.remove(params, config)
    end
  end

  describe "item create_processor_token/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "processor/token/create"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:processor_token)
        {:ok, mapper.(body)}
      end)

      assert {:ok, r} = Plaid.Item.create_processor_token(params, config)
      assert r.processor_token
      assert r.request_id
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:processor_token)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %{processor_token: _, request_id: _}} =
               Plaid.Item.create_processor_token(params, config)
    end
  end

  describe "item create_stripe_bank_account_token/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "processor/stripe/bank_account_token/create"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:stripe_bank_account_token)
        {:ok, mapper.(body)}
      end)

      assert {:ok, r} = Plaid.Item.create_stripe_bank_account_token(params, config)
      assert r.stripe_bank_account_token
      assert r.request_id
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:stripe_bank_account_token)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %{stripe_bank_account_token: _}} =
               Plaid.Item.create_stripe_bank_account_token(params, config)
    end
  end
end
