defmodule Plaid.InstitutionsTest do
  use ExUnit.Case, async: true

  import Mox

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
    test "makes post request to institutions/get endpoint", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "institutions/get"
        {:ok, %Plaid.HTTPClient.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :institutions
        {:ok, %Plaid.Institutions{}}
      end)

      assert {:ok, %Plaid.Institutions{}} = Plaid.Institutions.get(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Institutions.get(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Institutions data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:institutions)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Institutions{}} = Plaid.Institutions.get(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Institutions.get(params, config)
    end
  end

  describe "institutions get_by_id/2" do
    @tag :unit
    test "makes post request to institutions/get_by_id endpoint", %{
      params: params,
      config: config
    } do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "institutions/get_by_id"
        {:ok, %Plaid.HTTPClient.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :institution
        {:ok, %Plaid.Institutions.Institution{}}
      end)

      assert {:ok, %Plaid.Institutions.Institution{}} =
               Plaid.Institutions.get_by_id(params, config)
    end

    @tag :unit
    test "converts string parameter to map before calling make_request/4", %{config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, params, _config ->
        assert method == :post
        assert endpoint == "institutions/get_by_id"
        assert params == %{institution_id: "ins_1"}
        {:ok, %Plaid.HTTPClient.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :institution
        {:ok, %Plaid.Institutions.Institution{}}
      end)

      assert {:ok, %Plaid.Institutions.Institution{}} =
               Plaid.Institutions.get_by_id("ins_1", config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Institutions.get_by_id(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Institutions data structure" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:institution)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Institutions.Institution{}} =
               Plaid.Institutions.get_by_id("ins_1", config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Institutions.get_by_id("ins_1", config)
    end
  end

  describe "institutions search/2" do
    @tag :unit
    test "makes post request to institutions/get endpoint", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config -> true end)
      |> expect(:make_request, fn method, endpoint, _params, _config ->
        assert method == :post
        assert endpoint == "institutions/search"
        {:ok, %Plaid.HTTPClient.Response{}}
      end)
      |> expect(:handle_response, fn _response, endpoint, _config ->
        assert endpoint == :institutions
        {:ok, %Plaid.Institutions{}}
      end)

      assert {:ok, %Plaid.Institutions{}} = Plaid.Institutions.search(params, config)
    end

    @tag :unit
    test "raises if credentials aren't provided", %{params: params, config: config} do
      PlaidMock
      |> expect(:valid_credentials?, fn _config ->
        raise Plaid.MissingClientIdError
      end)

      assert_raise Plaid.MissingClientIdError, fn ->
        Plaid.Institutions.search(params, config)
      end
    end

    @tag :integration
    test "returns Plaid.Institutions data structure", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = Plaid.Factory.http_response_body(:institutions)

      Bypass.expect(bypass, fn conn ->
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Institutions{}} = Plaid.Institutions.search(params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Institutions.search(params, config)
    end
  end
end
