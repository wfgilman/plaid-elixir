defmodule Plaid.IdentityVerificationTest do
  use ExUnit.Case, async: true

  import Mox
  import Plaid.Factory

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

  @moduletag :identity_verification

  @tag :unit
  test "identity verification data structure encodes with Jason" do
    assert {:ok, _} =
             Jason.encode(%Plaid.IdentityVerification{
               template: %Plaid.IdentityVerification.Template{},
               user: %Plaid.IdentityVerification.User{
                 name: %Plaid.IdentityVerification.User.Name{},
                 address: %Plaid.IdentityVerification.User.Address{},
                 id_number: %Plaid.IdentityVerification.User.IDNumber{}
               },
               steps: %Plaid.IdentityVerification.Steps{},
               documentary_verification: %Plaid.IdentityVerification.DocumentaryVerification{
                 documents: [
                   %Plaid.IdentityVerification.DocumentaryVerification.Document{
                     images: [
                       %Plaid.IdentityVerification.DocumentaryVerification.Document.Image{}
                     ],
                     extracted_data:
                       %Plaid.IdentityVerification.DocumentaryVerification.Document.ExtractedData{},
                     analysis:
                       %Plaid.IdentityVerification.DocumentaryVerification.Document.Analysis{}
                   }
                 ]
               },
               selfie_check: %Plaid.IdentityVerification.SelfieCheck{
                 capture: [%Plaid.IdentityVerification.SelfieCheck.Capture{}],
                 analysis: %Plaid.IdentityVerification.SelfieCheck.Analysis{}
               }
             })
  end

  describe "identity_verification create/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      params = %{
        template_id: "idvtmp_4FrXJvfQU3zGUR",
        gave_consent: true,
        client_user_id: "your-db-id-3b24110"
      }

      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "identity_verification/create"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:identity_verification)
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.IdentityVerification.create(params, config)
      assert %Plaid.IdentityVerification{} = ds
      assert ds.id == "idv_52xR9LKo77r1Np"
      assert ds.status == "success"
      assert ds.user.email_address == "user@example.com"
      assert ds.user.name.given_name == "John"
      assert ds.template.id == "idvtmp_4FrXJvfQU3zGUR"
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      params = %{
        template_id: "idvtmp_4FrXJvfQU3zGUR",
        gave_consent: true,
        client_user_id: "your-db-id-3b24110"
      }

      body = http_response_body(:identity_verification)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.IdentityVerification{}} =
               Plaid.IdentityVerification.create(params, config)
    end

    @tag :integration
    test "error integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      params = %{
        template_id: "idvtmp_4FrXJvfQU3zGUR",
        gave_consent: true,
        client_user_id: "your-db-id-3b24110"
      }

      body = http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.IdentityVerification.create(params, config)
    end
  end

  describe "identity_verification get/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      params = %{identity_verification_id: "idv_52xR9LKo77r1Np"}

      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "identity_verification/get"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:identity_verification)
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.IdentityVerification.get(params, config)
      assert %Plaid.IdentityVerification{} = ds
      assert ds.id == "idv_52xR9LKo77r1Np"
      assert ds.steps.kyc_check == "success"
      assert ds.kyc_check.status == "success"
      assert ds.documentary_verification.status == "success"
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      params = %{identity_verification_id: "idv_52xR9LKo77r1Np"}
      body = http_response_body(:identity_verification)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.IdentityVerification{}} =
               Plaid.IdentityVerification.get(params, config)
    end

    @tag :integration
    test "error integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      params = %{identity_verification_id: "idv_52xR9LKo77r1Np"}
      body = http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.IdentityVerification.get(params, config)
    end
  end

  describe "identity_verification list/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      params = %{
        template_id: "idvtmp_4FrXJvfQU3zGUR",
        client_user_id: "your-db-id-3b24110"
      }

      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "identity_verification/list"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:identity_verification_list)
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.IdentityVerification.list(params, config)
      assert %Plaid.IdentityVerification.Verifications{} = ds
      assert length(ds.identity_verifications) == 2
      assert [first | _] = ds.identity_verifications
      assert %Plaid.IdentityVerification{} = first
      assert first.id == "idv_52xR9LKo77r1Np"
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      params = %{
        template_id: "idvtmp_4FrXJvfQU3zGUR",
        client_user_id: "your-db-id-3b24110"
      }

      body = http_response_body(:identity_verification_list)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.IdentityVerification.Verifications{}} =
               Plaid.IdentityVerification.list(params, config)
    end

    @tag :integration
    test "error integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      params = %{
        template_id: "idvtmp_4FrXJvfQU3zGUR",
        client_user_id: "your-db-id-3b24110"
      }

      body = http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.IdentityVerification.list(params, config)
    end
  end

  describe "identity_verification retry/2" do
    @tag :unit
    test "submits request and unmarshalls response", %{config: config} do
      params = %{
        client_user_id: "your-db-id-3b24110",
        template_id: "idvtmp_4FrXJvfQU3zGUR",
        strategy: "reset"
      }

      PlaidMock
      |> expect(:send_request, fn request, _client ->
        assert request.method == :post
        assert request.endpoint == "identity_verification/retry"
        assert %{metadata: _} = request.opts
        {:ok, %Tesla.Env{}}
      end)
      |> expect(:handle_response, fn _response, mapper ->
        body = http_response_body(:identity_verification)
        {:ok, mapper.(body)}
      end)

      assert {:ok, ds} = Plaid.IdentityVerification.retry(params, config)
      assert %Plaid.IdentityVerification{} = ds
      assert ds.id == "idv_52xR9LKo77r1Np"
      assert ds.client_user_id == "your-db-id-3b24110"
    end

    @tag :integration
    test "success integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      params = %{
        client_user_id: "your-db-id-3b24110",
        template_id: "idvtmp_4FrXJvfQU3zGUR",
        strategy: "reset"
      }

      body = http_response_body(:identity_verification)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, Poison.encode!(body))
      end)

      assert {:ok, %Plaid.IdentityVerification{}} =
               Plaid.IdentityVerification.retry(params, config)
    end

    @tag :integration
    test "error integration test" do
      bypass = Bypass.open()

      config = %{
        client_id: "test_id",
        secret: "test_secret",
        root_uri: "http://localhost:#{bypass.port}/"
      }

      params = %{
        client_user_id: "your-db-id-3b24110",
        template_id: "idvtmp_4FrXJvfQU3zGUR",
        strategy: "reset"
      }

      body = http_response_body(:error)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(400, Poison.encode!(body))
      end)

      assert {:error, %Plaid.Error{}} = Plaid.IdentityVerification.retry(params, config)
    end
  end
end
