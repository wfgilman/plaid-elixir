defmodule Plaid.ConnectTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
    add_params = %{username: "plaid_test", password: "plaid_good", type: "bofa",
                    options: %{login_only: true, webhook: "http://requestb.in/",
                      pending: false, start_date: "2015-01-01", end_date: "2015-03-31"},
                      list: true}
    add_bad_params = %{username: "plaid_test", password: "plaid_bad", type: "bofa"}
    mfa_choice_params = %{access_token: "test_chase", options: %{send_method:
                          %{type: "phone"}}}
    mfa_answer_params = %{access_token: "test_bofa", mfa: "tomato"}
    mfa_bad_answer_params = %{access_token: "test_bofa", mfa: "banana"}
    get_params = %{access_token: "test_bofa", options: %{pending: false,
                    account: "QPO8Jo8vdDHMepg41PBwckXm4KdK1yUdmXOwK",
                      gte: "2012-01-01", lte: "2016-01-01"}}
    get_bad_params = %{access_token: "bad_token", options: %{pending: false,
                        account: "QPO8Jo8vdDHMepg41PBwckXm4KdK1yUdmXOwK",
                          gte: "2012-01-01", lte: "2016-01-01"}}
    delete_params = %{access_token: "test_bofa"}
    delete_bad_params = %{access_token: "bad_token"}
    update_cred_params = %{username: "plaid_test", password: "plaid_good", access_token: "test_bofa"}
    update_mfa_params = %{access_token: "test_bofa", mfa: "tomato"}

    cred = %{client_id: "test_id", secret: "test_secret"}
    bad_cred = %{client_id: "foo", secret: "bar"}
    {:ok,
      cred: cred,
      bad_cred: bad_cred,
      add_params: add_params,
      bad_params: add_bad_params,
      mfa_choice_params: mfa_choice_params,
      mfa_answer_params: mfa_answer_params,
      mfa_bad_answer_params: mfa_bad_answer_params,
      get_params: get_params,
      get_bad_params: get_bad_params,
      delete_params: delete_params,
      delete_bad_params: delete_bad_params,
      update_cred_params: update_cred_params,
      update_mfa_params: update_mfa_params
    }
  end

  # Plaid.Connect.add/2 Tests
  @tag add: true
  test "Add user with MFA response, no credentials", %{add_params: params} do
    use_cassette "connect_test/add_mfa_resp_no_cred" do
      {:ok, resp} = Plaid.Connect.add(params)
      assert Plaid.Mfa == Map.get(resp, :__struct__)
    end
  end

  @tag add: true
  test "Add user with Connect response, no credentials", %{add_params: params} do
    use_cassette "connect_test/add_connect_resp_no_cred" do
      {:ok, resp} = Plaid.Connect.add(%{params | type: "wells"})
      assert Plaid.Connect == Map.get(resp, :__struct__)
    end
  end

  @tag add: true
  test "Add user with Error response, no credentials", %{add_bad_params: params} do
    use_cassette "connect_test/add_error_resp_no_cred" do
      {:error, resp} = Plaid.Connect.add(params)
      assert Plaid.Error == Map.get(resp, :__struct__)
    end
  end

  @tag add: true
  test "Add user with MFA response, credentials", %{add_params: params, cred: cred} do
    use_cassette "connect_test/add_mfa_resp_cred" do
      {:ok, resp} = Plaid.Connect.add(params, cred)
      assert Plaid.Mfa == Map.get(resp, :__struct__)
    end
  end

  @tag add: true
  test "Add user with MFA response, bad credentials", %{add_params: params, bad_cred: cred} do
    use_cassette "connect_test/add_mfa_resp_bad_cred" do
      {:error, resp} = Plaid.Connect.add(params, cred)
      assert Plaid.Error == Map.get(resp, :__struct__)
    end
  end

  # Plaid.Connect.mfa/2 Tests
  @tag mfa: true
  test "MFA choice confirmation, no credentials", %{mfa_choice_params: params} do
    use_cassette "connect_test/mfa_choice_no_cred" do
      {:ok, resp} = Plaid.Connect.mfa(params)
      assert Plaid.Mfa == Map.get(resp, :__struct__)
    end
  end

  @tag mfa: true
  test "MFA answer, no credentials", %{mfa_answer_params: params} do
    use_cassette "connect_test/mfa_answer_no_cred" do
      {:ok, resp} = Plaid.Connect.mfa(params)
      assert Plaid.Connect == Map.get(resp, :__struct__)
    end
  end

  @tag mfa: true
  test "MFA answer, credentials", %{mfa_answer_params: params, cred: cred} do
    use_cassette "connect_test/mfa_answer_cred" do
      {:ok, resp} = Plaid.Connect.mfa(params, cred)
      assert Plaid.Connect == Map.get(resp, :__struct__)
    end
  end

  @tag mfa: true
  test "MFA bad answer, credentials", %{mfa_bad_answer_params: params, cred: cred} do
    use_cassette "connect_test/mfa_bad_answer_cred" do
      {:error, resp} = Plaid.Connect.mfa(params, cred)
      assert Plaid.Error == Map.get(resp, :__struct__)
    end
  end


  # Plaid.Connect.get/2 test
  @tag get: true
  test "Get data, no credentials", %{get_params: params} do
    use_cassette "connect_test/get_data_no_cred" do
      {:ok, resp} = Plaid.Connect.get(params)
      assert Plaid.Connect == Map.get(resp, :__struct__)
    end
  end

  @tag get: true
  test "Get data, bad token, no credentials", %{get_bad_params: params} do
    use_cassette "connect_test/get_fail_no_cred" do
      {:error, resp} = Plaid.Connect.get(params)
      assert Plaid.Error == Map.get(resp, :__struct__)
    end
  end

  @tag get: true
  test "Get data, credentials", %{get_params: params, cred: cred} do
    use_cassette "connect_test/get_data_cred" do
      {:ok, resp} = Plaid.Connect.get(params, cred)
      assert Plaid.Connect == Map.get(resp, :__struct__)
    end
  end


  # Plaid.Connect.update/2 Tests
  @tag update: true
  test "Update user credentials, no credentials", %{update_cred_params: params} do
    use_cassette "connect_test/update_cred_no_cred" do
      {:ok, resp} = Plaid.Connect.update(params)
      assert Plaid.Mfa == Map.get(resp, :__struct__)
    end
  end

  @tag update: true
  test "Update user credentials, credentials", %{update_cred_params: params, cred: cred} do
    use_cassette "connect_test/update_cred_cred" do
      {:ok, resp} = Plaid.Connect.update(params, cred)
      assert Plaid.Mfa == Map.get(resp, :__struct__)
    end
  end

  @tag update: true
  test "Update user credentials, bad credentials", %{update_cred_params: params, bad_cred: cred} do
    use_cassette "connect_test/update_cred_bad_cred" do
      {:error, resp} = Plaid.Connect.update(params, cred)
      assert Plaid.Error == Map.get(resp, :__struct__)
    end
  end

  @tag update: true
  test "Update MFA credentials, no credentials", %{update_mfa_params: params} do
    use_cassette "connect_test/update_mfa_no_cred" do
      {:ok, resp} = Plaid.Connect.update(params)
      assert Plaid.Connect == Map.get(resp, :__struct__)
    end
  end

  # Plaid.Connect.delete/2 Tests
  @tag delete: true
  test "Delete user, no credentials", %{delete_params: params} do
    use_cassette "connect_test/delete_no_cred" do
      {:ok, resp} = Plaid.Connect.delete(params)
      assert Plaid.Message == Map.get(resp, :__struct__)
    end
  end

  @tag delete: true
  test "Delete user, bad token, no credentials", %{delete_bad_params: params} do
    use_cassette "connect_test/delete_fail_no_cred" do
      {:error, resp} = Plaid.Connect.delete(params)
      assert Plaid.Error == Map.get(resp, :__struct__)
    end
  end

  @tag delete: true
  test "Delete user, credentials", %{delete_params: params, cred: cred} do
    use_cassette "connect_test/delete_cred" do
      {:ok, resp} = Plaid.Connect.delete(params, cred)
      assert Plaid.Message == Map.get(resp, :__struct__)
    end
  end

end
