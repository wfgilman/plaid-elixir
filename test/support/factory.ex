defmodule Plaid.Factory do
  @moduledoc false

  def http_response_body(:accounts) do
    %{
      "accounts" => [
        %{
          "account_id" => "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
          "balances" => %{
            "available" => 100,
            "current" => 110,
            "limit" => nil,
            "iso_currency_code" => "USD",
            "unofficial_currency_code" => nil
          },
          "mask" => "0000",
          "name" => "Plaid Checking",
          "official_name" => "Plaid Gold Checking",
          "subtype" => "checking",
          "type" => "depository"
        },
        %{
          "account_id" => "6Myq63K1KDSe3lBwp7K1fnEbNGLV4nSxalVdW",
          "balances" => %{
            "available" => nil,
            "current" => 410,
            "limit" => 2000,
            "iso_currency_code" => "USD",
            "unofficial_currency_code" => nil
          },
          "mask" => "3333",
          "name" => "Plaid Credit Card",
          "official_name" => "Plaid Diamond Credit Card",
          "subtype" => "credit card",
          "type" => "credit"
        }
      ],
      "item" => %{
        "available_products" => ["balance", "auth"],
        "billed_products" => ["identity", "transactions"],
        "error" => nil,
        "institution_id" => "ins_109508",
        "item_id" => "Ed6bjNrDLJfGvZWwnkQlfxwoNz54B5C97ejBr",
        "webhook" => "https://plaid.com/example/hook"
      },
      "request_id" => "45QSn"
    }
  end

  def http_response_body(:auth) do
    account = http_response_body(:accounts)

    %{
      "accounts" => account["accounts"],
      "numbers" => %{
        "ach" => [
          %{
            "account" => "9900009606",
            "account_id" => "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
            "routing" => "011401533",
            "wire_routing" => "021000021"
          }
        ],
        "eft" => []
      },
      "item" => account["item"],
      "request_id" => "35QSp"
    }
  end

  def http_response_body(:item) do
    %{
      "access_token" => "access-sandbox-e9317406-8413",
      "item" => %{
        "available_products" => ["balance", "auth"],
        "billed_products" => ["identity", "transactions"],
        "error" => nil,
        "institution_id" => "ins_109508",
        "item_id" => "Ed6bjNrDLJfGvZWwnkQlfxwoNz54B5C97ejBr",
        "webhook" => "https://plaid.com/example/hook"
      },
      "request_id" => "qpCtl"
    }
  end

  def http_response_body(:exchange_public_token) do
    %{
      "access_token" => "access-sandbox-e9317406-8413",
      "item_id" => "Ed6bjNrDLJfGvZWwnkQlfxwoNz54B5C97ejBr",
      "request_id" => "qpCtl"
    }
  end

  def http_response_body(:create_public_token) do
    %{
      "public_token" => "public-sandbox-ae89b269-724d-48fe-af9a-cb31c2d1708a",
      "expiration" => "2017-08-12T21:24:42Z",
      "request_id" => "zxKj9"
    }
  end

  def http_response_body(:webhook) do
    %{
      "access_token" => "access-sandbox-e9317406-8413",
      "item" => %{
        "available_products" => ["balance", "auth"],
        "billed_products" => ["identity", "transactions"],
        "error" => nil,
        "institution_id" => "ins_109508",
        "item_id" => "Ed6bjNrDLJfGvZWwnkQlfxwoNz54B5C97ejBr",
        "webhook" => "https://plaid.com/updated/hook"
      },
      "request_id" => "qpCtl"
    }
  end

  def http_response_body(:rotate_access_token) do
    %{
      "new_access_token" => "access-sandbox-7c69d345-fd46",
      "request_id" => "ou2XQ"
    }
  end

  def http_response_body(:update_version_access_token) do
    %{
      "access_token" => "access-sandbox-x9v2d345-as9c",
      "request_id" => "c92aB"
    }
  end

  def http_response_body(:delete) do
    %{
      "deleted" => true,
      "request_id" => "s72lQ"
    }
  end

  def http_response_body(:error) do
    %{
      "error_type" => "INVALID_REQUEST",
      "error_code" => "MISSING_FIELDS",
      "error_message" => "Something went bad wrong.",
      "display_message" => "lol wut",
      "request_id" => "h12lD"
    }
  end

  def http_response_body(:categories) do
    %{
      "categories" => [
        %{
          "group" => "place",
          "hierarchy" => ["Recreation", "Arts & Entertainment", "Circuses and Carnivals"],
          "category_id" => "17001013"
        }
      ],
      "request_id" => "qpCtl"
    }
  end

  def http_response_body(:income) do
    %{
      "item" => %{
        "available_products" => ["balance", "auth"],
        "billed_products" => ["identity", "transactions"],
        "error" => nil,
        "institution_id" => "ins_109508",
        "item_id" => "Ed6bjNrDLJfGvZWwnkQlfxwoNz54B5C97ejBr",
        "webhook" => "https://plaid.com/example/hook"
      },
      "income" => %{
        "income_streams" => [
          %{
            "confidence" => 1,
            "days" => 518,
            "monthly_income" => 1601,
            "name" => "PLAID"
          },
          %{
            "confidence" => 0.95,
            "days" => 415,
            "monthly_income" => 1530,
            "name" => "BAGUETTES INC"
          }
        ],
        "last_year_income" => 28072,
        "last_year_income_before_tax" => 38681,
        "projected_yearly_income" => 19444,
        "projected_yearly_income_before_tax" => 26291,
        "max_number_of_overlapping_income_streams" => 2,
        "number_of_income_streams" => 3
      },
      "request_id" => "m8MDnv9okwxFNBV"
    }
  end

  def http_response_body(:institutions) do
    %{
      "institutions" => [
        %{
          "credentials" => [
            %{
              "label" => "User ID",
              "name" => "username",
              "type" => "text"
            },
            %{
              "label" => "Password",
              "name" => "password",
              "type" => "password"
            }
          ],
          "has_mfa" => true,
          "institution_id" => "ins_109509",
          "mfa" => ["code", "list", "questions", "selections"],
          "name" => "First Gingham Credit Union",
          "products" => ["balance", "credit_details", "auth", "transactions"]
        }
      ],
      "request_id" => "DLVvK"
    }
  end

  def http_response_body(:institution) do
    %{
      "institution" => %{
        "credentials" => [
          %{
            "label" => "User ID",
            "name" => "username",
            "type" => "text"
          },
          %{
            "label" => "Password",
            "name" => "password",
            "type" => "password"
          }
        ],
        "has_mfa" => true,
        "institution_id" => "ins_109512",
        "mfa" => ["code", "list", "questions", "selections"],
        "name" => "Houndstooth Bank",
        "products" => ["balance", "credit_details", "auth", "transactions"]
      },
      "request_id" => "9VpnU"
    }
  end

  def http_response_body(:transactions) do
    %{
      "accounts" => [
        %{
          "account_id" => "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
          "balances" => %{
            "available" => 100,
            "current" => 110,
            "limit" => nil,
            "iso_currency_code" => "USD",
            "unofficial_currency_code" => "USD"
          },
          "mask" => "0000",
          "name" => "Plaid Checking",
          "official_name" => "Plaid Gold Checking",
          "subtype" => "checking",
          "type" => "depository"
        },
        %{
          "account_id" => "6Myq63K1KDSe3lBwp7K1fnEbNGLV4nSxalVdW",
          "balances" => %{
            "available" => nil,
            "current" => 410,
            "limit" => 2000,
            "iso_currency_code" => "USD",
            "unofficial_currency_code" => "USD"
          },
          "mask" => "3333",
          "name" => "Plaid Credit Card",
          "official_name" => "Plaid Diamond Credit Card",
          "subtype" => "credit card",
          "type" => "credit"
        }
      ],
      "transactions" => [
        %{
          "account_id" => "vokyE5Rn6vHKqDLRXEn5fne7LwbKPLIXGK98d",
          "amount" => 2307.01,
          "iso_currency_code" => "USD",
          "unofficial_currency_code" => "USD",
          "category" => ["Shops", "Computers and Electronics"],
          "category_id" => "10913000",
          "date" => "2017-01-29",
          "location" => %{
            "address" => "300 Post St",
            "city" => "San Francisco",
            "state" => "CA",
            "zip" => "94108",
            "coordinates" => %{
              "lat" => nil,
              "lon" => nil
            }
          },
          "name" => "Apple Store",
          "payment_meta" => %{
            "by_order_of" => nil,
            "payee" => nil,
            "payer" => nil,
            "payment_method" => nil,
            "payment_processor" => nil,
            "ppd_id" => nil,
            "reason" => nil,
            "reference_number" => nil
          },
          "pending" => false,
          "pending_transaction_id" => nil,
          "account_owner" => nil,
          "transaction_id" => "lPNjeW1nR6CDn5okmGQ6hEpMo4lLNoSrzqDje",
          "transaction_type" => "place"
        },
        %{
          "account_id" => "XA96y1wW3xS7wKyEdbRzFkpZov6x1ohxMXwep",
          "amount" => 78.5,
          "iso_currency_code" => "USD",
          "unofficial_currency_code" => "USD",
          "category" => ["Food and Drink", "Restaurants"],
          "category_id" => "13005000",
          "date" => "2017-01-29",
          "location" => %{
            "address" => "262 W 15th St",
            "city" => "New York",
            "state" => "NY",
            "zip" => "10011",
            "coordinates" => %{
              "lat" => 40.740352,
              "lon" => -74.001761
            }
          },
          "name" => "Golden Crepes",
          "payment_meta" => %{
            "by_order_of" => nil,
            "payee" => nil,
            "payer" => nil,
            "payment_method" => nil,
            "payment_processor" => nil,
            "ppd_id" => nil,
            "reason" => nil,
            "reference_number" => nil
          },
          "pending" => false,
          "pending_transaction_id" => nil,
          "account_owner" => nil,
          "transaction_id" => "4WPD9vV5A1cogJwyQ5kVFB3vPEmpXPS3qvjXQ",
          "transaction_type" => "place"
        }
      ],
      "item" => %{
        "available_products" => ["balance", "auth"],
        "billed_products" => ["identity", "transactions"],
        "error" => nil,
        "institution_id" => "ins_109508",
        "item_id" => "Ed6bjNrDLJfGvZWwnkQlfxwoNz54B5C97ejBr",
        "webhook" => "https://plaid.com/example/hook"
      },
      "request_id" => "45QSn"
    }
  end

  def http_response_body(:processor_token) do
    %{
      "processor_token" => "processor-sandbox-asda9-a99c1-ca3g",
      "request_id" => "45QSn"
    }
  end
end
