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
      "request_id" => "qpCtl",
      "status" => %{
        "last_webhook" => nil,
        "transactions" => %{
          "last_failed_update" => nil,
          "last_successful_update" => "2020-05-19T23:16:55.038Z"
        }
      }
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

  def http_response_body(:"investments/transactions") do
    %{
      "accounts" => [
        %{
          "account_id" => "rxPW5z6P46CqqQm6Jy5ZI4Jdg5PGGBflwKgGg",
          "balances" => %{
            "available" => 100,
            "current" => 110,
            "iso_currency_code" => "USD",
            "limit" => nil,
            "unofficial_currency_code" => nil
          },
          "mask" => "0000",
          "name" => "Plaid Checking",
          "official_name" => "Plaid Gold Standard 0% Interest Checking",
          "subtype" => "checking",
          "type" => "depository"
        },
        %{
          "account_id" => "dLb3JWRbARtppGe9PEMlIKwdP5lEE7tZNgeXy",
          "balances" => %{
            "available" => nil,
            "current" => 320.76,
            "iso_currency_code" => "USD",
            "limit" => nil,
            "unofficial_currency_code" => nil
          },
          "mask" => "5555",
          "name" => "Plaid IRA",
          "official_name" => nil,
          "subtype" => "ira",
          "type" => "investment"
        }
      ],
      "investment_transactions" => [
        %{
          "account_id" => "dLb3JWRbARtppGe9PEMlIKwdP5lEE7tZNgeXy",
          "amount" => 46.32,
          "cancel_transaction_id" => nil,
          "date" => "2019-04-30",
          "fees" => nil,
          "investment_transaction_id" => "mKxX9R6xB6i55NXwjV76hAxG41RkX9FLoEveV",
          "iso_currency_code" => "USD",
          "name" => "BUY NFLX DERIVATIVE",
          "price" => 0.01,
          "quantity" => 4211.152345617756,
          "security_id" => "8E4L9XLl6MudjEpwPAAgivmdZRdBPJuvMPlPb",
          "type" => "buy",
          "unofficial_currency_code" => nil
        },
        %{
          "account_id" => "dLb3JWRbARtppGe9PEMlIKwdP5lEE7tZNgeXy",
          "amount" => -1200,
          "cancel_transaction_id" => nil,
          "date" => "2019-04-30",
          "fees" => nil,
          "investment_transaction_id" => "y71WbN61Z6hZZGqArW5BsgqV8xaGeltyaGqPV",
          "iso_currency_code" => "USD",
          "name" =>
            "INVBANKTRAN DEP CO CONTR CURRENT YR EMPLOYER CU CO CONTR CURRENT YR EMPLOYER CUR YR",
          "price" => 0,
          "quantity" => 0,
          "security_id" => "d6ePmbPxgWCWmMVv66q9iPV94n91vMtov5Are",
          "type" => "cash",
          "unofficial_currency_code" => nil
        }
      ],
      "item" => %{
        "available_products" => ["assets", "balance", "credit_details", "identity", "income"],
        "billed_products" => ["auth", "investments", "transactions"],
        "error" => nil,
        "institution_id" => "ins_3",
        "item_id" => "EQXBrmLXgLsZZbVM4JvGsG5LeLm9bgsXRLv4j",
        "webhook" => ""
      },
      "request_id" => "UfViDIZgENw05Cx",
      "securities" => [
        %{
          "close_price" => 0.011,
          "close_price_as_of" => nil,
          "cusip" => nil,
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => false,
          "isin" => nil,
          "iso_currency_code" => "USD",
          "name" => "Nflx Feb 01'18 $355 Call",
          "proxy_security_id" => nil,
          "security_id" => "8E4L9XLl6MudjEpwPAAgivmdZRdBPJuvMPlPb",
          "sedol" => nil,
          "ticker_symbol" => "NFLX180201C00355000",
          "type" => "derivative",
          "unofficial_currency_code" => nil
        },
        %{
          "close_price" => 42.15,
          "close_price_as_of" => nil,
          "cusip" => "464286400",
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => false,
          "isin" => "US4642864007",
          "iso_currency_code" => "USD",
          "name" => "iShares Inc MSCI Brazil",
          "proxy_security_id" => nil,
          "security_id" => "abJamDazkgfvBkVGgnnLUWXoxnomp5up8llg4",
          "sedol" => nil,
          "ticker_symbol" => "EWZ",
          "type" => "etf",
          "unofficial_currency_code" => nil
        },
        %{
          "close_price" => 1,
          "close_price_as_of" => nil,
          "cusip" => nil,
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => true,
          "isin" => nil,
          "iso_currency_code" => "USD",
          "name" => "U S Dollar",
          "proxy_security_id" => nil,
          "security_id" => "d6ePmbPxgWCWmMVv66q9iPV94n91vMtov5Are",
          "sedol" => nil,
          "ticker_symbol" => "USD",
          "type" => "cash",
          "unofficial_currency_code" => nil
        }
      ],
      "total_investment_transactions" => 326
    }
  end

  def http_response_body(:"investments/holdings") do
    %{
      "accounts" => [
        %{
          "account_id" => "rxPW5z6P46CqqQm6Jy5ZI4Jdg5PGGBflwKgGg",
          "balances" => %{
            "available" => 100,
            "current" => 110,
            "iso_currency_code" => "USD",
            "limit" => nil,
            "unofficial_currency_code" => nil
          },
          "mask" => "0000",
          "name" => "Plaid Checking",
          "official_name" => "Plaid Gold Standard 0% Interest Checking",
          "subtype" => "checking",
          "type" => "depository"
        },
        %{
          "account_id" => "dLb3JWRbARtppGe9PEMlIKwdP5lEE7tZNgeXy",
          "balances" => %{
            "available" => nil,
            "current" => 320.76,
            "iso_currency_code" => "USD",
            "limit" => nil,
            "unofficial_currency_code" => nil
          },
          "mask" => "5555",
          "name" => "Plaid IRA",
          "official_name" => nil,
          "subtype" => "ira",
          "type" => "investment"
        },
        %{
          "account_id" => "aZDr3gRDLRcaaQ4gDlkdsLJKWjAZZgC74dLXJ",
          "balances" => %{
            "available" => nil,
            "current" => 23631.9805,
            "iso_currency_code" => "USD",
            "limit" => nil,
            "unofficial_currency_code" => nil
          },
          "mask" => "6666",
          "name" => "Plaid 401k",
          "official_name" => nil,
          "subtype" => "401k",
          "type" => "investment"
        }
      ],
      "holdings" => [
        %{
          "account_id" => "dLb3JWRbARtppGe9PEMlIKwdP5lEE7tZNgeXy",
          "cost_basis" => 1,
          "institution_price" => 1,
          "institution_price_as_of" => nil,
          "institution_value" => 0.01,
          "iso_currency_code" => "USD",
          "quantity" => 0.01,
          "security_id" => "d6ePmbPxgWCWmMVv66q9iPV94n91vMtov5Are",
          "unofficial_currency_code" => nil
        },
        %{
          "account_id" => "aZDr3gRDLRcaaQ4gDlkdsLJKWjAZZgC74dLXJ",
          "cost_basis" => 1.5,
          "institution_price" => 2.11,
          "institution_price_as_of" => nil,
          "institution_value" => 2.11,
          "iso_currency_code" => "USD",
          "quantity" => 1,
          "security_id" => "KDwjlXj1Rqt58dVvmzRguxJybmyQL8FgeWWAy",
          "unofficial_currency_code" => nil
        },
        %{
          "account_id" => "aZDr3gRDLRcaaQ4gDlkdsLJKWjAZZgC74dLXJ",
          "cost_basis" => 10,
          "institution_price" => 10.42,
          "institution_price_as_of" => nil,
          "institution_value" => 20.84,
          "iso_currency_code" => "USD",
          "quantity" => 2,
          "security_id" => "NDVQrXQoqzt5v3bAe8qRt4A7mK7wvZCLEBBJk",
          "unofficial_currency_code" => nil
        },
        %{
          "account_id" => "dLb3JWRbARtppGe9PEMlIKwdP5lEE7tZNgeXy",
          "cost_basis" => 0.01,
          "institution_price" => 0.011,
          "institution_price_as_of" => nil,
          "institution_value" => 110,
          "iso_currency_code" => "USD",
          "quantity" => 10000,
          "security_id" => "8E4L9XLl6MudjEpwPAAgivmdZRdBPJuvMPlPb",
          "unofficial_currency_code" => nil
        }
      ],
      "item" => %{
        "available_products" => ["assets", "balance", "credit_details", "identity", "income"],
        "billed_products" => ["auth", "investments", "transactions"],
        "error" => nil,
        "institution_id" => "ins_3",
        "item_id" => "EQXBrmLXgLsZZbVM4JvGsG5LeLm9bgsXRLv4j",
        "webhook" => ""
      },
      "request_id" => "8lT4oybo5jl3JMp",
      "securities" => [
        %{
          "close_price" => 0.011,
          "close_price_as_of" => nil,
          "cusip" => nil,
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => false,
          "isin" => nil,
          "iso_currency_code" => "USD",
          "name" => "Nflx Feb 01'18 $355 Call",
          "proxy_security_id" => nil,
          "security_id" => "8E4L9XLl6MudjEpwPAAgivmdZRdBPJuvMPlPb",
          "sedol" => nil,
          "ticker_symbol" => "NFLX180201C00355000",
          "type" => "derivative",
          "unofficial_currency_code" => nil
        },
        %{
          "close_price" => 27,
          "close_price_as_of" => nil,
          "cusip" => "577130834",
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => false,
          "isin" => "US5771308344",
          "iso_currency_code" => "USD",
          "name" => "Matthews Pacific Tiger Fund Insti Class",
          "proxy_security_id" => nil,
          "security_id" => "JDdP7XPMklt5vwPmDN45t3KAoWAPmjtpaW7DP",
          "sedol" => nil,
          "ticker_symbol" => "MIPTX",
          "type" => "mutual fund",
          "unofficial_currency_code" => nil
        },
        %{
          "close_price" => 2.11,
          "close_price_as_of" => nil,
          "cusip" => "00448Q201",
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => false,
          "isin" => "US00448Q2012",
          "iso_currency_code" => "USD",
          "name" => "Achillion Pharmaceuticals Inc.",
          "proxy_security_id" => nil,
          "security_id" => "KDwjlXj1Rqt58dVvmzRguxJybmyQL8FgeWWAy",
          "sedol" => nil,
          "ticker_symbol" => "ACHN",
          "type" => "equity",
          "unofficial_currency_code" => nil
        },
        %{
          "close_price" => 24.5,
          "close_price_as_of" => nil,
          "cusip" => "00769G543",
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => false,
          "isin" => "US00769G5430",
          "iso_currency_code" => "USD",
          "name" => "Cambiar International Equity Institutional",
          "proxy_security_id" => nil,
          "security_id" => "MD9eKXeplrt5yKRlzLqXiavwb6wrdxUb3wdnM",
          "sedol" => nil,
          "ticker_symbol" => "CAMYX",
          "type" => "mutual fund",
          "unofficial_currency_code" => nil
        },
        %{
          "close_price" => 10.42,
          "close_price_as_of" => nil,
          "cusip" => "258620103",
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => false,
          "isin" => "US2586201038",
          "iso_currency_code" => "USD",
          "name" => "DoubleLine Total Return Bond Fund",
          "proxy_security_id" => nil,
          "security_id" => "NDVQrXQoqzt5v3bAe8qRt4A7mK7wvZCLEBBJk",
          "sedol" => nil,
          "ticker_symbol" => "DBLTX",
          "type" => "mutual fund",
          "unofficial_currency_code" => nil
        },
        %{
          "close_price" => 42.15,
          "close_price_as_of" => nil,
          "cusip" => "464286400",
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => false,
          "isin" => "US4642864007",
          "iso_currency_code" => "USD",
          "name" => "iShares Inc MSCI Brazil",
          "proxy_security_id" => nil,
          "security_id" => "abJamDazkgfvBkVGgnnLUWXoxnomp5up8llg4",
          "sedol" => nil,
          "ticker_symbol" => "EWZ",
          "type" => "etf",
          "unofficial_currency_code" => nil
        },
        %{
          "close_price" => 1,
          "close_price_as_of" => nil,
          "cusip" => nil,
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => true,
          "isin" => nil,
          "iso_currency_code" => "USD",
          "name" => "U S Dollar",
          "proxy_security_id" => nil,
          "security_id" => "d6ePmbPxgWCWmMVv66q9iPV94n91vMtov5Are",
          "sedol" => nil,
          "ticker_symbol" => "USD",
          "type" => "cash",
          "unofficial_currency_code" => nil
        },
        %{
          "close_price" => 34.73,
          "close_price_as_of" => nil,
          "cusip" => "84470P109",
          "institution_id" => nil,
          "institution_security_id" => nil,
          "is_cash_equivalent" => false,
          "isin" => "US84470P1093",
          "iso_currency_code" => "USD",
          "name" => "Southside Bancshares Inc.",
          "proxy_security_id" => nil,
          "security_id" => "eW4jmnjd6AtjxXVrjmj6SX1dNEdZp3Cy8RnRQ",
          "sedol" => nil,
          "ticker_symbol" => "SBSI",
          "type" => "equity",
          "unofficial_currency_code" => nil
        },
        %{
          "close_price" => 13.73,
          "close_price_as_of" => nil,
          "cusip" => nil,
          "institution_id" => "ins_115617",
          "institution_security_id" => "NHX105509",
          "is_cash_equivalent" => false,
          "isin" => nil,
          "iso_currency_code" => "USD",
          "name" => "NH PORTFOLIO 1055 (FIDELITY INDEX)",
          "proxy_security_id" => nil,
          "security_id" => "nnmo8doZ4lfKNEDe3mPJipLGkaGw3jfPrpxoN",
          "sedol" => nil,
          "ticker_symbol" => "NHX105509",
          "type" => "etf",
          "unofficial_currency_code" => nil
        }
      ]
    }
  end
end
