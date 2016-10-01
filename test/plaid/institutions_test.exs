defmodule Plaid.InstitutionsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
  end

  test "Search long-tail institutions by query and product" do
    use_cassette "institutions_test/search_q_p" do
      assert {:ok, _} = Plaid.Institutions.long_tail_search("wells","auth")
    end
  end

  test "Search long-tail institutions by query" do
    use_cassette "institutions_test/search_q" do
      assert {:ok, _} = Plaid.Institutions.long_tail_search("wells")
    end
  end
end
