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
        "logo" =>
          "iVBORw0KGgoAAAANSUhEUgAAAJgAAACYCAMAAAAvHNATAAAANlBMVEVHcEwOW6f///8IVqUPW6gQXKgRXKkPW6gTYKwPW6gbYqsxcbJ3ocza5vDs8/b0+Pmlwt1Vir96WNmQAAAACnRSTlMA////5HhLoCDGuAtrFAAABQNJREFUeNrt3H9vpCAQBuACIuC6wn7/L3vuXttb8UX5MdjJpVya3D9tngDiqDPz8dE67KiNcc4NgxDDsP7HGD3aj58cVhu3avAYnNE/wbOjSZredObauctCveGuWsAC1aet/6Ja7UTVcF1t1oiGYSxLVjdaO6sLjYZFT9OTIBuTpju2nCAdbmS2irTrOQ6iwxiaJ02LTqNtp9n07lJT7kjtNNtjGdUt3JfMMSvq5Uwvo3osMn+kZLXLaTDp9jyL7rJkBJGgGTKXeCw3teqKXH6VCTKZw/Pl/RM2y8KRnDNHcjk+t1YdTIZJUVycdsCX4rrlK2Fp2WBb11Hcnlu+FibvU/tq4nV8uaphXt5vrTJz4KqfMemTMtNyTny6GmBStsnwef99pLbA5JKSZdwDRnzH/j7qm2ByeSRkY9VBoaYgKWA+LTs9NNAFqUSQkmbG1t9PyFzNBguSDiZ9ItjQxRts42qHJWVj6QYLkhaWCtAOtpk5d5HAEjJTtJCxgQSWCNDG/CtyT6CB4QDNZV+RQEAEwzJ4ZdoJBazdYDBAm2zWzkcuOhgM0MD+t3kuQphHMns+YYlnRzoYDNDM6YS9Avy+MBig2bMJS7hoYUBmjifsK5DuDQNhkD2asLSLGuZ3MnMwYQcuahiYM5s+9NdA2l8G24WOOnWXVIfvcuhhcYDmEiv5HuBfA4vDIAtX8uXyJ7DHnXg88FoOyUAaw8REPjahLAwQg8yArSFL0b+/v5L8UYmA0aQD6RSs7zC7lVx3te8CU2dDgLW04A0FMWwKx2OO/qiNt1gnmLqdrUP0MWCMt1g32FJ2/Jv4sPg5mAwq3mRWsIDdp3iTaY4wHYVibGAmiizYwFx0o2QDe+5+wREmoliMD8xuQws+sHEb7vOB6e2DGx+Y4QtzPGHuF1YMG3jCBr4wwRMm+MJ+91gp7Pcc+29gv9FFKYxtoMg2tGb7MML28Y3vAy/bVwRsX6qwfQ3F9sUdk1edG9jA5+XwFmbi1+mKCWyMP0BkfO+7BGb3H98CB9gAvtRP890fjqUTbJn2H7m2eWPT7XjUfOLK+DLyPmMj/JAqSr6TkcHeM0OG/jU+2bDNBtHwY70iHxmwbe6FRekN6jETj+fH/RPY1uVwQsitrIAmK3XhBBZlhGicQnOSdtEBFmeq2FTSEbHsDBYnEpuDNK1wHczvknXtUWJbuG7GZnWcC7hN71HhKtiszrInzVY2XwML6jTf1J7kWHeBhdPcSZANOPvusH1as8lIacb5uZSwkJfSvLuVE8mSMJBsrfPS5svqTkthwOVyCw1IZBDmYQr4mFuaoRTBLR3PWGZqerKYhUAGYagK7qhmahT0MgSD1XljWcFUswzAoEuXlpg9AzRPCoNPgK6iKK8tQNvBYF3eeSXvKIhlMQzXC45VhZ+qJUCLYLhaUNeWyjYEaFsYdjUU8dbLtrC5wYVrzapDx3cYrmBsLRSf606Nd1irK1FoObfCoGsoa0YAa3mrArR/sADnq7SDCZYtDbDQuo5H12aF7AsG6xapWoSoCtknDNagVrnw+7zyYOMF87DdRXXvHtgep1D2Kn65IVdLtyN0cRbO2WvLT8Dl2vpD6TbZkuw/09zsCyynmkrec8IxEHT6svDqzH8zDK9GmrZt1Y3RUj1U6Do+Mm0lx7j5Ht92hYwbPDJuicm4iSjjtqucG9Vybu37vagMmyG/z12X9tF/APITr9CCbDsMAAAAAElFTkSuQmCC",
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
      "link_token" => "link-sandbox-234a923f-8908-41de-a30e-354a3cd5dfef",
      "expiration" => "2020-08-25T11:00:49Z",
      "request_id" => "7mtxj0CIzYXiFq2"
    }
  end
end
