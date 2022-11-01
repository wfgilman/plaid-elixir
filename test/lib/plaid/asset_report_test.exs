defmodule Plaid.AssetReportTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

  setup do
    verify_on_exit!()

    {:ok,
     params: %{asset_report_token: "assets-sandbox-6f12f5bb"},
     config: %{
       client: PlaidMock,
       client_id: "test_id",
       secret: "test_secret",
       root_uri: "http://localhost:4000/"
     }}
  end

  @moduletag :asset_report

  @tag :unit
  test "asset_report data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.AssetReport{
               items: [%Plaid.AssetReport.Item{}],
               user: %Plaid.AssetReport.User{},
               warnings: [%Plaid.AssetReport.Warning{cause: %Plaid.AssetReport.Warning.Cause{}}]
             })
  end

  describe "asset create_asset_report/4" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "asset_report/create"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:create_asset_report)
        {:ok, mapper.(body)}
      end)

      params = %{access_token: "my-token", days_requested: 30}
      assert {:ok, r} = Plaid.AssetReport.create_asset_report(params, config)

      assert r.asset_report_token
      assert r.asset_report_id
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

      body = http_response_body(:create_asset_report)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok,
              %{asset_report_id: _, asset_report_token: _, request_id: _}} =
               Plaid.AssetReport.create_asset_report(params, config)
    end
  end

  describe "asset get/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{params: params, config: config} do
      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "asset_report/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:get_asset_report)
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.AssetReport.get(params, config)
      assert Plaid.AssetReport == ds.__struct__
      assert Plaid.AssetReport.Item == List.first(ds.items).__struct__
      assert Plaid.AssetReport.User == ds.user.__struct__
      assert ds.user.client_user_id
      assert Plaid.AssetReport.Warning == List.first(ds.warnings).__struct__
      assert Plaid.AssetReport.Warning.Cause == List.first(ds.warnings).cause.__struct__
    end

    @tag :integration
    test "success integration test", %{params: params} do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:get_asset_report)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.AssetReport{}} = Plaid.AssetReport.get(params, config)
    end
  end
end
