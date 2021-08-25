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
          "type" => "depository",
          "verification_status" => nil
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
          "type" => "credit",
          "verification_status" => nil
        },
        %{
          "account_id" => "dhfDuX0N3Yia57IMOGE3m7faUlwvPQLbxs7Oc",
          "balances" => %{
            "available" => 200,
            "current" => 500,
            "limit" => 4000,
            "iso_currency_code" => "USD",
            "unofficial_currency_code" => nil
          },
          "mask" => "9876",
          "name" => "Plaid Platinum Checking",
          "official_name" => "Plaid Platinum Checking",
          "subtype" => "checking",
          "type" => "depository",
          "verification_status" => "automatically_verified"
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
        "eft" => [
          %{
            "account" => "111122223333",
            "account_id" => "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
            "institution" => "021",
            "branch" => "01140"
          }
        ],
        "international" => [
          %{
            "account_id" => "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
            "bic" => "NWBKGB21",
            "iban" => "GB29NWBK60161331926819"
          }
        ],
        "bacs" => [
          %{
            "account" => "31926819",
            "account_id" => "vzeNDwK7KQIm4yEog683uElbp9GRLEFXGK98D",
            "sort_code" => "601613"
          }
        ]
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
        "last_webhook" => %{
          "sent_at" => "2019-02-15T15:53:00Z",
          "code_sent" => "DEFAULT_UPDATE"
        },
        "transactions" => %{
          "last_failed_update" => nil,
          "last_successful_update" => "2020-05-19T23:16:55.038Z"
        },
        "investments" => %{
          "last_successful_update" => "2019-05-23T19:51:00Z",
          "last_failed_update" => "2019-03-15T02:10:00Z"
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

  def http_response_body(:remove) do
    %{
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
          "country_codes" => ["US"],
          "credentials" => [
            %{"label" => "Username", "name" => "username", "type" => "text"},
            %{"label" => "Password", "name" => "password", "type" => "password"}
          ],
          "has_mfa" => true,
          "input_spec" => "fixed",
          "institution_id" => "ins_112060",
          "logo" =>
            "iVBORw0KGgoAAAANSUhEUgAAAJgAAACYCAMAAAAvHNATAAAA2FBMVEVHcEz////////////////////////////////////////////////////////////////////////QExbQDxHc5OLY2tnl5ub7+/zVP0XZ39719vZQICrq7Oz+/v7v8fHPCgvTBQa5GB3WEBFETFbPBAbWUVbZ0NDbx8kqMTtpcHY3PUciJS+ZnqPUJSkXHSc4JzF5foW6vcDFyMrO0dOts7b4w8pcY2vYZGqpGB3c7OpOVV3609mlqa3ooqi/FRhWXGSLj5ThsrbigIfZvL+QHiVuHif85ek+7ovgAAAAEnRSTlMAlmmfqoE15SESS9TAus/KxqM83ZL5AAAO+klEQVR42syaj1+izBPHs+xQu+4u5McKsZC/EkQN8Eed4SPZXf//f/SdBVRQlkWp5/mOZuSr695+ZnZmdpaLi5JW/9a4vqre/rrhOIw47ubXbfXquvGtfvEfWu2ycsvxseHEK7ngbiuXtf8E6m7HRDfu7t+Fa1S4vTb5hjFXafxLWl1zfFGsyLuYu/5y3eqXP/mz7OflVy6HWgXxZxuqfJVstSvMlzJ89RVo36olsUK06rfPVqvKf4ph/u5TVbtE/KcZuvw8L97wn2o3n+PP+hX/6Xb1CbmjwfFfYFzpanDNf5Fdl1uM3/kvs++1/zc3lnfnNf+1hs90Z4X/cqucw1WlNVhnGYWsenr2ooQ91olp+qFpmZe6ur2glY7vJ2a0+o/sv6NqkrIzURHByIUY/bz9cXsd/hy+SjKN7MdJZHVKEVJFSXoc5Ntj4jW8gstHUZERxZ039dJ6YSRL4lt/3GJaHx7kSS765HKlSLJaXjNKfAGX8tbq9R4eHnrG7tEzwMgLuer1yDtgD70Hgzyj3+613hS6N7+XW4+glyICl9BpZ9pL4vqf5Hsv7X8EIMuJs2qp/KWCH9/7htB5uc+0J9p7T09/2xGZhsrks2ta3Cu/38aG0PzzNLQcxyFf4YtFtwV5LKy1ef8iGOMVrFB0fklvUNfj77eW0ez8eerOtJTJYCI89qZF36JsIslTy75vNo3xG1mbFDJm3axxOVyCAFxDH5FN7O4ZPrZzi/hdnNoRY2lp/2kKRusdyChrk6udtSAJ13tLaBI/+urp1doDso4gtN5/UzX7fk6AYZlw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",
          "mfa" => ["code", "list", "questions", "selections"],
          "mfa_code_type" => "numeric",
          "name" => "1st Bank (Broadus, MT) - Personal",
          "oauth" => false,
          "primary_color" => "#c02f27",
          "products" => ["assets", "auth", "balance", "transactions", "income", "identity"],
          "routing_numbers" => [],
          "status" => %{
            "auth" => %{
              "breakdown" => %{
                "error_institution" => 0.08,
                "error_plaid" => 0.01,
                "success" => 0.91
              },
              "last_status_change" => "2019-02-15T15:53:00Z",
              "status" => "HEALTHY"
            },
            "balance" => %{
              "breakdown" => %{
                "error_institution" => 0.09,
                "error_plaid" => 0.02,
                "success" => 0.89
              },
              "last_status_change" => "2019-02-15T15:53:00Z",
              "status" => "HEALTHY"
            },
            "identity" => %{
              "breakdown" => %{
                "error_institution" => 0.5,
                "error_plaid" => 0.08,
                "success" => 0.42
              },
              "last_status_change" => "2019-02-15T15:50:00Z",
              "status" => "DEGRADED"
            },
            "item_logins" => %{
              "breakdown" => %{
                "error_institution" => 0.09,
                "error_plaid" => 0.01,
                "success" => 0.9
              },
              "last_status_change" => "2019-02-15T15:53:00Z",
              "status" => "HEALTHY"
            },
            "transactions_updates" => %{
              "breakdown" => %{
                "error_institution" => 0.03,
                "error_plaid" => 0.02,
                "refresh_interval" => "NORMAL",
                "success" => 0.95
              },
              "last_status_change" => "2019-02-12T08:22:00Z",
              "status" => "HEALTHY"
            }
          },
          "url" => "http://www.our1stbank.com/"
        }
      ],
      "request_id" => "jReUm681mVpt1Ck",
      "total" => 11389
    }
  end

  def http_response_body(:institution) do
    %{
      "institution" => %{
        "country_codes" => ["US"],
        "credentials" => [
          %{"label" => "Username", "name" => "username", "type" => "text"},
          %{"label" => "Password", "name" => "password", "type" => "password"}
        ],
        "has_mfa" => true,
        "input_spec" => "fixed",
        "institution_id" => "ins_114024",
        "logo" =>
          "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",
        "mfa" => ["code", "list", "questions", "selections"],
        "mfa_code_type" => "numeric",
        "name" => "Fortera Credit Union",
        "oauth" => false,
        "primary_color" => "#004966",
        "products" => ["assets", "auth", "balance", "transactions", "income", "identity"],
        "routing_numbers" => [],
        "status" => %{
          "auth" => %{
            "breakdown" => %{
              "error_institution" => 0.08,
              "error_plaid" => 0.01,
              "success" => 0.91
            },
            "last_status_change" => "2019-02-15T15:53:00Z",
            "status" => "HEALTHY"
          },
          "balance" => %{
            "breakdown" => %{
              "error_institution" => 0.09,
              "error_plaid" => 0.02,
              "success" => 0.89
            },
            "last_status_change" => "2019-02-15T15:53:00Z",
            "status" => "HEALTHY"
          },
          "identity" => %{
            "breakdown" => %{
              "error_institution" => 0.5,
              "error_plaid" => 0.08,
              "success" => 0.42
            },
            "last_status_change" => "2019-02-15T15:50:00Z",
            "status" => "DEGRADED"
          },
          "item_logins" => %{
            "breakdown" => %{
              "error_institution" => 0.09,
              "error_plaid" => 0.01,
              "success" => 0.9
            },
            "last_status_change" => "2019-02-15T15:53:00Z",
            "status" => "HEALTHY"
          },
          "transactions_updates" => %{
            "breakdown" => %{
              "error_institution" => 0.03,
              "error_plaid" => 0.02,
              "refresh_interval" => "NORMAL",
              "success" => 0.95
            },
            "last_status_change" => "2019-02-12T08:22:00Z",
            "status" => "HEALTHY"
          }
        },
        "url" => "https://www.forteracu.com/"
      },
      "request_id" => "O9AZsnAaPO23Aiw"
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
          "category" => [
            "Shops",
            "Computers and Electronics"
          ],
          "category_id" => "19013000",
          "date" => "2017-01-29",
          "authorized_date" => "2017-01-27",
          "location" => %{
            "address" => "300 Post St",
            "city" => "San Francisco",
            "region" => "CA",
            "postal_code" => "94108",
            "country" => "US",
            "lat" => nil,
            "lon" => nil,
            "store_number" => "1235"
          },
          "merchant_name" => "Apple",
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
          "payment_channel" => "in store",
          "pending" => false,
          "pending_transaction_id" => nil,
          "account_owner" => nil,
          "transaction_id" => "lPNjeW1nR6CDn5okmGQ6hEpMo4lLNoSrzqDje",
          "transaction_code" => nil,
          "transaction_type" => "place"
        },
        %{
          "account_id" => "XA96y1wW3xS7wKyEdbRzFkpZov6x1ohxMXwep",
          "amount" => 78.5,
          "iso_currency_code" => "USD",
          "unofficial_currency_code" => "USD",
          "category" => [
            "Food and Drink",
            "Restaurants"
          ],
          "category_id" => "13005000",
          "date" => "2017-01-29",
          "authorized_date" => "2017-01-28",
          "location" => %{
            "address" => "262 W 15th St",
            "city" => "New York",
            "region" => "NY",
            "postal_code" => "10011",
            "country" => "US",
            "lat" => 40.740352,
            "lon" => -74.001761,
            "store_number" => "455"
          },
          "merchant_name" => "Golden Crepes",
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
          "payment_channel" => "in store",
          "pending" => false,
          "pending_transaction_id" => nil,
          "account_owner" => nil,
          "transaction_id" => "4WPD9vV5A1cogJwyQ5kVFB3vPEmpXPS3qvjXQ",
          "transaction_code" => nil,
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

  def http_response_body(:stripe_bank_account_token) do
    %{
      "stripe_bank_account_token" => "stripe-sandbox-asda9-a99c1-ca3g",
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

  def http_response_body(:identity) do
    %{
      accounts: [
        %{
          "account_id" => "xaP8RrNRZVtPNPQRl1DbsVL33NlB3jin7yRJ7",
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
          "owners" => [
            %{
              "addresses" => [
                %{
                  "data" => %{
                    "city" => "Malakoff",
                    "country" => "US",
                    "postal_code" => "14236",
                    "region" => "NY",
                    "street" => "2992 Cameron Road"
                  },
                  "primary" => true
                },
                %{
                  "data" => %{
                    "city" => "San Matias",
                    "country" => "US",
                    "postal_code" => "93405-2255",
                    "region" => "CA",
                    "street" => "2493 Leisure Lane"
                  },
                  "primary" => false
                }
              ],
              "emails" => [
                %{
                  "data" => "accountholder0@example.com",
                  "primary" => true,
                  "type" => "primary"
                },
                %{
                  "data" => "accountholder1@example.com",
                  "primary" => false,
                  "type" => "secondary"
                },
                %{
                  "data" => "extraordinarily.long.email.username.123456@reallylonghostname.com",
                  "primary" => false,
                  "type" => "other"
                }
              ],
              "names" => ["Alberta Bobbeth Charleson"],
              "phone_numbers" => [
                %{
                  "data" => "1112223333",
                  "primary" => false,
                  "type" => "home"
                },
                %{
                  "data" => "1112224444",
                  "primary" => false,
                  "type" => "work"
                },
                %{
                  "data" => "1112225555",
                  "primary" => false,
                  "type" => "mobile1"
                }
              ]
            }
          ],
          "subtype" => "checking",
          "type" => "depository"
        },
        %{
          "account_id" => "jGA4kbDkKVCALA38kKWQsB6EE7dgEbt1Mv8Zo",
          "balances" => %{
            "available" => 200,
            "current" => 210,
            "iso_currency_code" => "USD",
            "limit" => nil,
            "unofficial_currency_code" => nil
          },
          "mask" => "1111",
          "name" => "Plaid Saving",
          "official_name" => "Plaid Silver Standard 0.1% Interest Saving",
          "owners" => [
            %{
              "addresses" => [
                %{
                  "data" => %{
                    "city" => "Malakoff",
                    "country" => "US",
                    "postal_code" => "14236",
                    "region" => "NY",
                    "street" => "2992 Cameron Road"
                  },
                  "primary" => true
                },
                %{
                  "data" => %{
                    "city" => "San Matias",
                    "country" => "US",
                    "postal_code" => "93405-2255",
                    "region" => "CA",
                    "street" => "2493 Leisure Lane"
                  },
                  "primary" => false
                }
              ],
              "emails" => [
                %{
                  "data" => "accountholder0@example.com",
                  "primary" => true,
                  "type" => "primary"
                },
                %{
                  "data" => "accountholder1@example.com",
                  "primary" => false,
                  "type" => "secondary"
                },
                %{
                  "data" => "extraordinarily.long.email.username.123456@reallylonghostname.com",
                  "primary" => false,
                  "type" => "other"
                }
              ],
              "names" => ["Alberta Bobbeth Charleson"],
              "phone_numbers" => [
                %{
                  "data" => "1112223333",
                  "primary" => false,
                  "type" => "home"
                },
                %{
                  "data" => "1112224444",
                  "primary" => false,
                  "type" => "work"
                },
                %{
                  "data" => "1112225555",
                  "primary" => false,
                  "type" => "mobile1"
                }
              ]
            }
          ],
          "subtype" => "savings",
          "type" => "depository"
        },
        %{
          "account_id" => "74BnLpGLWAIEVENwbpJKHoMrrnVbrpcgl8KMN",
          "balances" => %{
            "available" => nil,
            "current" => 1000,
            "iso_currency_code" => "USD",
            "limit" => nil,
            "unofficial_currency_code" => nil
          },
          "mask" => "2222",
          "name" => "Plaid CD",
          "official_name" => "Plaid Bronze Standard 0.2% Interest CD",
          "owners" => [
            %{
              "addresses" => [
                %{
                  "data" => %{
                    "city" => "Malakoff",
                    "country" => "US",
                    "postal_code" => "14236",
                    "region" => "NY",
                    "street" => "2992 Cameron Road"
                  },
                  "primary" => true
                },
                %{
                  "data" => %{
                    "city" => "San Matias",
                    "country" => "US",
                    "postal_code" => "93405-2255",
                    "region" => "CA",
                    "street" => "2493 Leisure Lane"
                  },
                  "primary" => false
                }
              ],
              "emails" => [
                %{
                  "data" => "accountholder0@example.com",
                  "primary" => true,
                  "type" => "primary"
                },
                %{
                  "data" => "accountholder1@example.com",
                  "primary" => false,
                  "type" => "secondary"
                },
                %{
                  "data" => "extraordinarily.long.email.username.123456@reallylonghostname.com",
                  "primary" => false,
                  "type" => "other"
                }
              ],
              "names" => ["Alberta Bobbeth Charleson"],
              "phone_numbers" => [
                %{
                  "data" => "1112223333",
                  "primary" => false,
                  "type" => "home"
                },
                %{
                  "data" => "1112224444",
                  "primary" => false,
                  "type" => "work"
                },
                %{
                  "data" => "1112225555",
                  "primary" => false,
                  "type" => "mobile1"
                }
              ]
            }
          ],
          "subtype" => "cd",
          "type" => "depository"
        },
        %{
          "account_id" => "egoByv9y8Vcjzjb4QwENTEP33pQn3auLdal7L",
          "balances" => %{
            "available" => nil,
            "current" => 410,
            "iso_currency_code" => "USD",
            "limit" => 2000,
            "unofficial_currency_code" => nil
          },
          "mask" => "3333",
          "name" => "Plaid Credit Card",
          "official_name" => "Plaid Diamond 12.5% APR Interest Credit Card",
          "owners" => [
            %{
              "addresses" => [
                %{
                  "data" => %{
                    "city" => "Malakoff",
                    "country" => "US",
                    "postal_code" => "14236",
                    "region" => "NY",
                    "street" => "2992 Cameron Road"
                  },
                  "primary" => true
                },
                %{
                  "data" => %{
                    "city" => "San Matias",
                    "country" => "US",
                    "postal_code" => "93405-2255",
                    "region" => "CA",
                    "street" => "2493 Leisure Lane"
                  },
                  "primary" => false
                }
              ],
              "emails" => [
                %{
                  "data" => "accountholder0@example.com",
                  "primary" => true,
                  "type" => "primary"
                },
                %{
                  "data" => "accountholder1@example.com",
                  "primary" => false,
                  "type" => "secondary"
                },
                %{
                  "data" => "extraordinarily.long.email.username.123456@reallylonghostname.com",
                  "primary" => false,
                  "type" => "other"
                }
              ],
              "names" => ["Alberta Bobbeth Charleson"],
              "phone_numbers" => [
                %{
                  "data" => "1112223333",
                  "primary" => false,
                  "type" => "home"
                },
                %{
                  "data" => "1112224444",
                  "primary" => false,
                  "type" => "work"
                },
                %{
                  "data" => "1112225555",
                  "primary" => false,
                  "type" => "mobile1"
                }
              ]
            }
          ],
          "subtype" => "credit card",
          "type" => "credit"
        },
        %{
          "account_id" => "QrKL7Jj7aoh5o5G3ZwVBsK1oo8RAontpMGW3w",
          "balances" => %{
            "available" => 43200,
            "current" => 43200,
            "iso_currency_code" => "USD",
            "limit" => nil,
            "unofficial_currency_code" => nil
          },
          "mask" => "4444",
          "name" => "Plaid Money Market",
          "official_name" => "Plaid Platinum Standard 1.85% Interest Money Market",
          "owners" => [
            %{
              "addresses" => [
                %{
                  "data" => %{
                    "city" => "Malakoff",
                    "country" => "US",
                    "postal_code" => "14236",
                    "region" => "NY",
                    "street" => "2992 Cameron Road"
                  },
                  "primary" => true
                },
                %{
                  "data" => %{
                    "city" => "San Matias",
                    "country" => "US",
                    "postal_code" => "93405-2255",
                    "region" => "CA",
                    "street" => "2493 Leisure Lane"
                  },
                  "primary" => false
                }
              ],
              "emails" => [
                %{
                  "data" => "accountholder0@example.com",
                  "primary" => true,
                  "type" => "primary"
                },
                %{
                  "data" => "accountholder1@example.com",
                  "primary" => false,
                  "type" => "secondary"
                },
                %{
                  "data" => "extraordinarily.long.email.username.123456@reallylonghostname.com",
                  "primary" => false,
                  "type" => "other"
                }
              ],
              "names" => ["Alberta Bobbeth Charleson"],
              "phone_numbers" => [
                %{
                  "data" => "1112223333",
                  "primary" => false,
                  "type" => "home"
                },
                %{
                  "data" => "1112224444",
                  "primary" => false,
                  "type" => "work"
                },
                %{
                  "data" => "1112225555",
                  "primary" => false,
                  "type" => "mobile1"
                }
              ]
            }
          ],
          "subtype" => "money market",
          "type" => "depository"
        },
        %{
          "account_id" => "ZPNnpqopGVhKmKJeWjBlHN3LLvqkLAigRJDrJ",
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
          "owners" => [
            %{
              "addresses" => [
                %{
                  "data" => %{
                    "city" => "Malakoff",
                    "country" => "US",
                    "postal_code" => "14236",
                    "region" => "NY",
                    "street" => "2992 Cameron Road"
                  },
                  "primary" => true
                },
                %{
                  "data" => %{
                    "city" => "San Matias",
                    "country" => "US",
                    "postal_code" => "93405-2255",
                    "region" => "CA",
                    "street" => "2493 Leisure Lane"
                  },
                  "primary" => false
                }
              ],
              "emails" => [
                %{
                  "data" => "accountholder0@example.com",
                  "primary" => true,
                  "type" => "primary"
                },
                %{
                  "data" => "accountholder1@example.com",
                  "primary" => false,
                  "type" => "secondary"
                },
                %{
                  "data" => "extraordinarily.long.email.username.123456@reallylonghostname.com",
                  "primary" => false,
                  "type" => "other"
                }
              ],
              "names" => ["Alberta Bobbeth Charleson"],
              "phone_numbers" => [
                %{
                  "data" => "1112223333",
                  "primary" => false,
                  "type" => "home"
                },
                %{
                  "data" => "1112224444",
                  "primary" => false,
                  "type" => "work"
                },
                %{
                  "data" => "1112225555",
                  "primary" => false,
                  "type" => "mobile1"
                }
              ]
            }
          ],
          "subtype" => "ira",
          "type" => "investment"
        },
        %{
          "account_id" => "MyAQR7aRBMS5q5jmoe8Vs6LxxdnZxRt9l48ee",
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
          "owners" => [
            %{
              "addresses" => [
                %{
                  "data" => %{
                    "city" => "Malakoff",
                    "country" => "US",
                    "postal_code" => "14236",
                    "region" => "NY",
                    "street" => "2992 Cameron Road"
                  },
                  "primary" => true
                },
                %{
                  "data" => %{
                    "city" => "San Matias",
                    "country" => "US",
                    "postal_code" => "93405-2255",
                    "region" => "CA",
                    "street" => "2493 Leisure Lane"
                  },
                  "primary" => false
                }
              ],
              "emails" => [
                %{
                  "data" => "accountholder0@example.com",
                  "primary" => true,
                  "type" => "primary"
                },
                %{
                  "data" => "accountholder1@example.com",
                  "primary" => false,
                  "type" => "secondary"
                },
                %{
                  "data" => "extraordinarily.long.email.username.123456@reallylonghostname.com",
                  "primary" => false,
                  "type" => "other"
                }
              ],
              "names" => ["Alberta Bobbeth Charleson"],
              "phone_numbers" => [
                %{
                  "data" => "1112223333",
                  "primary" => false,
                  "type" => "home"
                },
                %{
                  "data" => "1112224444",
                  "primary" => false,
                  "type" => "work"
                },
                %{
                  "data" => "1112225555",
                  "primary" => false,
                  "type" => "mobile1"
                }
              ]
            }
          ],
          "subtype" => "401k",
          "type" => "investment"
        },
        %{
          "account_id" => "1zGgLloLDpIqpqP9mbx5HD8jjkK7jGt5KqGZm",
          "balances" => %{
            "available" => nil,
            "current" => 65262,
            "iso_currency_code" => "USD",
            "limit" => nil,
            "unofficial_currency_code" => nil
          },
          "mask" => "7777",
          "name" => "Plaid Student Loan",
          "official_name" => nil,
          "owners" => [
            %{
              "addresses" => [
                %{
                  "data" => %{
                    "city" => "Malakoff",
                    "country" => "US",
                    "postal_code" => "14236",
                    "region" => "NY",
                    "street" => "2992 Cameron Road"
                  },
                  "primary" => true
                },
                %{
                  "data" => %{
                    "city" => "San Matias",
                    "country" => "US",
                    "postal_code" => "93405-2255",
                    "region" => "CA",
                    "street" => "2493 Leisure Lane"
                  },
                  "primary" => false
                }
              ],
              "emails" => [
                %{
                  "data" => "accountholder0@example.com",
                  "primary" => true,
                  "type" => "primary"
                },
                %{
                  "data" => "accountholder1@example.com",
                  "primary" => false,
                  "type" => "secondary"
                },
                %{
                  "data" => "extraordinarily.long.email.username.123456@reallylonghostname.com",
                  "primary" => false,
                  "type" => "other"
                }
              ],
              "names" => ["Alberta Bobbeth Charleson"],
              "phone_numbers" => [
                %{
                  "data" => "1112223333",
                  "primary" => false,
                  "type" => "home"
                },
                %{
                  "data" => "1112224444",
                  "primary" => false,
                  "type" => "work"
                },
                %{
                  "data" => "1112225555",
                  "primary" => false,
                  "type" => "mobile1"
                }
              ]
            }
          ],
          "subtype" => "student",
          "type" => "loan"
        }
      ],
      item: %{
        "available_products" => [
          "assets",
          "balance",
          "credit_details",
          "income",
          "investments",
          "liabilities",
          "transactions"
        ],
        "billed_products" => ["auth", "identity"],
        "error" => nil,
        "institution_id" => "ins_3",
        "item_id" => "1zGgLloLDpIqpqP9mbx5HD8LGbvpGGC57l4Lq",
        "webhook" => ""
      },
      request_id: "vnfz2k6XTtgjpbX"
    }
  end

  def http_response_body(:create_link_token) do
    %{
      "link_token" => "link-production-840204-193734",
      "created_at" => "2020-03-26T12:56:34",
      "expiration" => "2020-03-27T12:56:34",
      "metadata" => %{
        "initial_products" => [
          "auth"
        ],
        "webhook" => "https://example.com/webhook",
        "country_codes" => [
          "US",
          "CA"
        ],
        "language" => "en",
        "account_filters" => %{
          "depository" => [
            "checking"
          ]
        },
        "redirect_uri" => "https://example.com/redirect",
        "client_name" => "Example Client Name"
      }
    }
  end

  def http_response_body(:get_link_token) do
    %{
      "link_token" => "link-production-840204-193734",
      "created_at" => "2020-03-26T12:56:34",
      "expiration" => "2020-03-27T12:56:34",
      "metadata" => %{
        "initial_products" => [
          "auth"
        ],
        "webhook" => "https://example.com/webhook",
        "country_codes" => [
          "US",
          "CA"
        ],
        "language" => "en",
        "account_filters" => %{
          "depository" => [
            "checking"
          ]
        },
        "redirect_uri" => "https://example.com/redirect",
        "client_name" => "Example Client Name"
      }
    }
  end

  def http_response_body(:webhook_verification_key) do
    %{
      "key" => %{
        "alg" => "ES256",
        "created_at" => 1_560_466_150,
        "crv" => "P-256",
        "expired_at" => nil,
        "kid" => "bfbd5111-8e33-4643-8ced-b2e642a72f3c",
        "kty" => "EC",
        "use" => "sig",
        "x" => "hKXLGIjWvCBv-cP5euCTxl8g9GLG9zHo_3pO5NN1DwQ",
        "y" => "shhexqPB7YffGn6fR6h2UhTSuCtPmfzQJ6ENVIoO4Ys"
      },
      "request_id" => "RZ6Omi1bzzwDaLo"
    }
  end

  def http_response_body(:"payment_initiation/payment/create") do
    %{
      "payment_id" => "payment-id-sandbox-feca8a7a-5591-4aef-9297-f3062bb735d3",
      "status" => "PAYMENT_STATUS_INPUT_NEEDED",
      "request_id" => "4ciYVmesrySiUAB"
    }
  end

  def http_response_body(:"payment_initiation/payment/get") do
    %{
      "payment_id" => "payment-id-sandbox-feca8a7a-5591-4aef-9297-f3062bb735d3",
      "payment_token" => "payment-token-sandbox-c6a26505-42b4-46fe-8ecf-bf9edcafbebb",
      "reference" => "Account Funding 99744",
      "amount" => %{
        "currency" => "GBP",
        "value" => 100
      },
      "status" => "PAYMENT_STATUS_INPUT_NEEDED",
      "last_status_update" => "2019-11-06T21:10:52Z",
      "payment_expiration_time" => "2019-11-06T21:25:52Z",
      "recipient_id" => "recipient-id-sandbox-9b6b4679-914b-445b-9450-efbdb80296f6",
      "request_id" => "aEAQmewMzlVa1k6"
    }
  end

  def http_response_body(:"payment_initiation/payment/list") do
    %{
      "payments" => [
        %{
          "payment_id" => "payment-id-sandbox-feca8a7a-5591-4aef-9297-f3062bb735d3",
          "payment_token" => "payment-token-sandbox-c6a26505-42b4-46fe-8ecf-bf9edcafbebb",
          "reference" => "Account Funding 99744",
          "amount" => %{
            "currency" => "GBP",
            "value" => 100
          },
          "status" => "PAYMENT_STATUS_INPUT_NEEDED",
          "last_status_update" => "2019-11-06T21:10:52Z",
          "payment_expiration_time" => "2019-11-06T21:25:52Z",
          "recipient_id" => "recipient-id-sandbox-9b6b4679-914b-445b-9450-efbdb80296f6"
        }
      ],
      "next_cursor" => "2020-01-01T00:00:00Z",
      "request_id" => "aEAQmewMzlVa1k6"
    }
  end

  def http_response_body(:"payment_initiation/recipient/create") do
    %{
      "recipient_id" => "recipient-id-sandbox-9b6b4679-914b-445b-9450-efbdb80296f6",
      "request_id" => "4zlKapIkTm8p5KM"
    }
  end

  def http_response_body(:"payment_initiation/recipient/get") do
    %{
      "recipient_id" => "recipient-id-sandbox-9b6b4679-914b-445b-9450-efbdb80296f6",
      "name" => "Wonder Wallet",
      "iban" => "GB29NWBK60161331926819",
      "address" => %{
        "street" => [
          "96 Guild Street",
          "9th Floor"
        ],
        "city" => "London",
        "postal_code" => "SE14 8JW",
        "country" => "GB"
      },
      "request_id" => "4zlKapIkTm8p5KM"
    }
  end

  def http_response_body(:"payment_initiation/recipient/list") do
    %{
      "recipients" => [
        %{
          "recipient_id" => "recipient-id-sandbox-9b6b4679-914b-445b-9450-efbdb80296f6",
          "name" => "Wonder Wallet",
          "iban" => "GB29NWBK60161331926819",
          "address" => %{
            "street" => [
              "96 Guild Street",
              "9th Floor"
            ],
            "city" => "London",
            "postal_code" => "SE14 8JW",
            "country" => "GB"
          }
        }
      ],
      "request_id" => "4zlKapIkTm8p5KM"
    }
  end
end
