defmodule Plaid.IncomeTest do
  use ExUnit.Case

  import Plaid.Factory

  setup do
    bypass = Bypass.open()
    Application.put_env(:plaid, :root_uri, "http://localhost:#{bypass.port}/")
    {:ok, bypass: bypass}
  end

  describe "income" do
    test "get/1 requests POST and returns Plaid.Income", %{bypass: bypass} do
      body = http_response_body(:income)

      Bypass.expect(bypass, fn conn ->
        assert "POST" == conn.method
        Plug.Conn.resp(conn, 200, Poison.encode!(body))
      end)

      assert {:ok, resp} = Plaid.Income.get(%{access_token: "my-token"})

      assert Plaid.Income == resp.__struct__
      assert {:ok, _} = Jason.encode(resp)

      %{
        "income" => %{
          "income_streams" => [
            income_stream_1,
            income_stream_2
          ],
          "last_year_income" => last_year_income,
          "last_year_income_before_tax" => last_year_income_before_tax,
          "max_number_of_overlapping_income_streams" => max_number_of_overlapping_income_streams,
          "number_of_income_streams" => number_of_income_streams,
          "projected_yearly_income" => projected_yearly_income,
          "projected_yearly_income_before_tax" => projected_yearly_income_before_tax
        },
        "item" => _,
        "request_id" => _
      } = body

      assert last_year_income == 28072
      assert last_year_income_before_tax == 38681
      assert max_number_of_overlapping_income_streams == 2
      assert number_of_income_streams == 3
      assert projected_yearly_income == 19444
      assert projected_yearly_income_before_tax == 26291

      assert income_stream_1 == %{
               "confidence" => 1,
               "days" => 518,
               "monthly_income" => 1601,
               "name" => "PLAID"
             }

      assert income_stream_2 == %{
               "confidence" => 0.95,
               "days" => 415,
               "monthly_income" => 1530,
               "name" => "BAGUETTES INC"
             }
    end
  end
end
