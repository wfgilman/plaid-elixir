defmodule Plaid.InstitutionsTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

  setup do
    verify_on_exit!()
    {:ok, params: %{access_token: "my-token"}, config: %{client: PlaidMock}}
  end

  @moduletag :institutions

  @tag :unit
  test "instititutions data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.Institutions{
               institutions: [
                 %Plaid.Institutions.Institution{
                   credentials: [%Plaid.Institutions.Institution.Credentials{}],
                   status: %Plaid.Institutions.Institution.Status{
                     item_logins: %Plaid.Institutions.Institution.Status.ItemLogins{
                       breakdown: %Plaid.Institutions.Institution.Status.ItemLogins.Breakdown{}
                     },
                     transactions_updates:
                       %Plaid.Institutions.Institution.Status.TransactionsUpdates{
                         breakdown:
                           %Plaid.Institutions.Institution.Status.TransactionsUpdates.Breakdown{}
                       },
                     auth: %Plaid.Institutions.Institution.Status.Auth{
                       breakdown: %Plaid.Institutions.Institution.Status.Auth.Breakdown{}
                     },
                     balance: %Plaid.Institutions.Institution.Status.Balance{
                       breakdown: %Plaid.Institutions.Institution.Status.Balance.Breakdown{}
                     },
                     identity: %Plaid.Institutions.Institution.Status.Identity{
                       breakdown: %Plaid.Institutions.Institution.Status.Identity.Breakdown{}
                     }
                   }
                 }
               ]
             })
  end

  describe "institutions get/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "institutions/get"
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:institutions)}
      end)

      assert {:ok, ds} = Plaid.Institutions.get(params, config)
      assert Plaid.Institutions == ds.__struct__
      assert Plaid.Institutions.Institution == List.first(ds.institutions).__struct__
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:institutions)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Institutions{}} = Plaid.Institutions.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Institutions.get(params, config)
    end
  end

  describe "institutions get_by_id/2" do
    @tag :unit
    test "sends request and unmarshalls response", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "institutions/get_by_id"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:institution)}
      end)

      assert {:ok, ds} = Plaid.Institutions.get_by_id(params, config)
      assert Plaid.Institutions.Institution == ds.__struct__
      assert ds.request_id
    end

    @tag :unit
    test "converts string parameter to map before calling send_request/2", %{config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.body == %{institution_id: "ins_1"}
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:institution)}
      end)

      Plaid.Institutions.get_by_id("ins_1", config)
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:institution)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Institutions.Institution{}} =
               Plaid.Institutions.get_by_id("ins_1", config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Institutions.get_by_id("ins_1", config)
    end
  end

  describe "institutions search/2" do
    @tag :unit
    test "sends request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "institutions/search"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response ->
        {:ok, http_response_body(:institutions)}
      end)

      assert {:ok, ds} = Plaid.Institutions.search(params, config)
      assert Plaid.Institutions == ds.__struct__
      assert Plaid.Institutions.Institution == List.first(ds.institutions).__struct__
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:institutions)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Institutions{}} = Plaid.Institutions.search(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Institutions.search(params, config)
    end
  end
end
