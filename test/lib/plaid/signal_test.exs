defmodule Plaid.SignalTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

  @evaluate_params %{
    "access_token" => "access-sandbox-71e02f71-0960-4a27-abd2-5631e04f2175",
    "account_id" => "3gE5gnRzNyfXpBK5wEEKcymJ5albGVUqg77gr",
    "client_transaction_id" => "txn12345",
    "amount" => 123.45,
    "client_user_id" => "user1234",
    "user" => %{
      "name" => %{
        "prefix" => "Ms.",
        "given_name" => "Jane",
        "middle_name" => "Leah",
        "family_name" => "Doe",
        "suffix" => "Jr."
      },
      "phone_number" => "+14152223333",
      "email_address" => "jane.doe@example.com",
      "address" => %{
        "street" => "2493 Leisure Lane",
        "city" => "San Matias",
        "region" => "CA",
        "postal_code" => "93405-2255",
        "country" => "US"
      }
    },
    "device" => %{
      "ip_address" => "198.30.2.2",
      "user_agent" => "Mozilla/5.0 (iPhone; CPU iPhone OS 13_5_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.1 Mobile/15E148 Safari/604.1"
    },
    "user_present" => true
  }

  @report_decision_params %{
    "client_transaction_id" => "txn123",
    "initiated" => "true",
    "decision_outcome" => "APPROVE",
    "payment_method" => "NEXT_DAY_ACH",
    "days_funds_on_hold" => 3,
    "amount_instantly_available" => 123.45
  }

  @report_return_params %{
    "client_transaction_id" => "txn12345",
    "return_code" => "R01",
    "returned_at" => "2024-07-30T12:34:56Z"
  }

  @prepare_params %{
    "access_token" => "access-sandbox-71e02f71-0960-4a27-abd2-5631e04f2175"
  }

  setup do
    verify_on_exit!()

    {:ok,
     config: %{
       client: PlaidMock,
       client_id: "test_id",
       secret: "test_secret",
       root_uri: "http://localhost:4000/"
     }}
  end

  @moduletag :identity

  @tag :unit
  test "signal data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.Signal{
              scores: %Plaid.Signal.Scores{
                customer_initiated_return_risk: %Plaid.Signal.Scores.Risk{},
                bank_initiated_return_risk: %Plaid.Signal.Scores.Risk{},
              },
              warnings: [%Plaid.Signal.Warning{}],
              ruleset: %Plaid.Signal.Ruleset{}
            })
  end

  describe "signal evaluate/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      body = http_response_body(:signal_evaluate)

      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "signal/evaluate"
        assert %{metadata: _} = request.opts
        assert request.body == @evaluate_params
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        {:ok, mapper.(body)}
      end)

      expected_result = %Plaid.Signal{
        scores: %Plaid.Signal.Scores{
          customer_initiated_return_risk: %Plaid.Signal.Scores.Risk{
            score: body["scores"]["customer_initiated_return_risk"]["score"],
            risk_tier: body["scores"]["customer_initiated_return_risk"]["risk_tier"]
          },
          bank_initiated_return_risk: %Plaid.Signal.Scores.Risk{
            score: body["scores"]["bank_initiated_return_risk"]["score"],
            risk_tier: body["scores"]["bank_initiated_return_risk"]["risk_tier"]
          }
        },
        core_attributes: body["core_attributes"],
        warnings: body["warnings"] |> Enum.map(&(%Plaid.Signal.Warning{
          warning_code: &1["warning_code"],
          warning_type: &1["warning_type"],
          warning_message: &1["warning_message"],
        })),
        ruleset: %Plaid.Signal.Ruleset{
          outcome: body["ruleset"]["outcome"],
          ruleset_key: body["ruleset"]["ruleset_key"]
        },
        request_id: body["request_id"]
      }

      assert {:ok, ^expected_result} = Plaid.Signal.evaluate(@evaluate_params, config)
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:signal_evaluate)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.Signal{}} = Plaid.Signal.evaluate(@evaluate_params, config)
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

      assert {:error, %Plaid.Error{}} = Plaid.Signal.evaluate(@evaluate_params, config)
    end
  end

  describe "signal report_decision/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      body = http_response_body(:signal_report_decision)
      request_id = body["request_id"]

      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "signal/decision/report"
        assert %{metadata: _} = request.opts
        assert request.body == @report_decision_params
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        {:ok, mapper.(body)}
      end)

      assert {:ok, %{request_id: ^request_id}} = Plaid.Signal.report_decision(
        @report_decision_params,
        config
      )
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:signal_report_decision)
      request_id = body["request_id"]

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %{request_id: ^request_id}} = Plaid.Signal.report_decision(
        @report_decision_params,
        config
      )
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

      assert {:error, %Plaid.Error{}} = Plaid.Signal.report_decision(
        @report_decision_params,
        config
      )
    end
  end

  describe "signal report_return/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      body = http_response_body(:signal_report_return)
      request_id = body["request_id"]

      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "signal/return/report"
        assert %{metadata: _} = request.opts
        assert request.body == @report_return_params
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        {:ok, mapper.(body)}
      end)

      assert {:ok, %{request_id: ^request_id}} = Plaid.Signal.report_return(
        @report_return_params,
        config
      )
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:signal_report_return)
      request_id = body["request_id"]

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %{request_id: ^request_id}} = Plaid.Signal.report_return(
        @report_return_params,
        config
      )
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

      assert {:error, %Plaid.Error{}} = Plaid.Signal.report_return(
        @report_return_params,
        config
      )
    end
  end

  describe "signal prepare/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      body = http_response_body(:signal_prepare)
      request_id = body["request_id"]

      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "signal/prepare"
        assert %{metadata: _} = request.opts
        assert request.body == @prepare_params
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        {:ok, mapper.(body)}
      end)

      assert {:ok, %{request_id: ^request_id}} = Plaid.Signal.prepare(
        @prepare_params,
        config
      )
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      body = http_response_body(:signal_prepare)
      request_id = body["request_id"]

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %{request_id: ^request_id}} = Plaid.Signal.prepare(
        @prepare_params,
        config
      )
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

      assert {:error, %Plaid.Error{}} = Plaid.Signal.prepare(@prepare_params, config)
    end
  end
end
