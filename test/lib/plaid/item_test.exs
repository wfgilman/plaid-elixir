defmodule Plaid.ItemTest do
  use ExUnit.Case, async: true

  import Mox

  setup do
    verify_on_exit!()
    {:ok, params: %{access_token: "my-token"}, config: %{client: PlaidMock}}
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
    test "makes post request to item/get endpoint", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "item/get"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :item
        {:ok, %Plaid.Item{}}
      end)

      assert {:ok, %Plaid.Item{}} = Plaid.Item.get(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Item.get(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Item data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:item)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Item{}} = Plaid.Item.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Item.get(params, config)
    end
  end

  describe "item exchange_public_token/2" do
    @tag :unit
    test "makes post request to item/public_token/exchange endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "item/public_token/exchange"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :item
        {:ok, %{access_token: "new-token"}}
      end)

      assert {:ok, %{access_token: _}} = Plaid.Item.exchange_public_token(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Item.exchange_public_token(params, config)
      end
    end

    @tag :integration
    test "returns access token", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:exchange_public_token)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %{access_token: _}} = Plaid.Item.get(params, config)
    end
  end

  describe "item create_public_token/2" do
    @tag :unit
    test "makes post request to item/public_token/create endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "item/public_token/create"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :item
        {:ok, %{public_token: "new-token"}}
      end)

      assert {:ok, %{public_token: _}} = Plaid.Item.create_public_token(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Item.create_public_token(params, config)
      end
    end

    @tag :integration
    test "returns public token", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:create_public_token)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %{public_token: _}} = Plaid.Item.create_public_token(params, config)
    end
  end

  describe "item update_webhook/2" do
    @tag :unit
    test "makes post request to item/webhook/update endpoint", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "item/webhook/update"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :item
        {:ok, %Plaid.Item{}}
      end)

      assert {:ok, %Plaid.Item{}} = Plaid.Item.update_webhook(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Item.update_webhook(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Item data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:webhook)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Item{}} = Plaid.Item.create_public_token(params, config)
    end
  end

  describe "item rotate_access_token/2" do
    @tag :unit
    test "makes post request to item/access_token/invalidate endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "item/access_token/invalidate"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :item
        {:ok, %{new_access_token: "new-token"}}
      end)

      assert {:ok, %{new_access_token: _}} = Plaid.Item.rotate_access_token(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Item.rotate_access_token(params, config)
      end
    end

    @tag :integration
    test "returns new access token", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:rotate_access_token)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %{new_access_token: _}} = Plaid.Item.rotate_access_token(params, config)
    end
  end

  describe "item update_version_access_token/2" do
    @tag :unit
    test "makes post request to item/access_token/update_version endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "item/access_token/update_version"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :item
        {:ok, %{access_token: "new-token"}}
      end)

      assert {:ok, %{access_token: _}} = Plaid.Item.update_version_access_token(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Item.update_version_access_token(params, config)
      end
    end

    @tag :integration
    test "returns access token", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:update_version_access_token)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %{access_token: _}} = Plaid.Item.update_version_access_token(params, config)
    end
  end

  describe "item remove/2" do
    @tag :unit
    test "makes post request to item/remove endpoint", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "item/remove"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :item
        {:ok, %{request_id: "AbCdEfG"}}
      end)

      assert {:ok, %{request_id: _}} = Plaid.Item.remove(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Item.remove(params, config)
      end
    end

    @tag :integration
    test "returns request_id", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:remove)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %{request_id: _}} = Plaid.Item.remove(params, config)
    end
  end

  describe "item create_processor_token/2" do
    @tag :unit
    test "makes post request to processor/token/create endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "processor/token/create"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :item
        {:ok, %{processor_token: "my-token"}}
      end)

      assert {:ok, %{processor_token: _}} = Plaid.Item.create_processor_token(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Item.create_processor_token(params, config)
      end
    end

    @tag :integration
    test "returns processor token", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:processor_token)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %{processor_token: _}} = Plaid.Item.create_processor_token(params, config)
    end
  end

  describe "item create_stripe_bank_account_token/2" do
    @tag :unit
    test "makes post request to processor/stripe/bank_account_token/create endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "processor/stripe/bank_account_token/create"
        {:ok, %PlaidHTTP.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :item
        {:ok, %{stripe_bank_account_token: "my-token"}}
      end)

      assert {:ok, %{stripe_bank_account_token: _}} =
               Plaid.Item.create_stripe_bank_account_token(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Item.create_stripe_bank_account_token(params, config)
      end
    end

    @tag :integration
    test "returns stripe bank account token", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:stripe_bank_account_token)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %{stripe_bank_account_token: _}} =
               Plaid.Item.create_stripe_bank_account_token(params, config)
    end
  end
end
