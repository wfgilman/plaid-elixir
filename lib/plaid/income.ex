defmodule Plaid.Income do
  @moduledoc """
  Functions for Plaid `income` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, get_cred: 0]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct item: nil, income: nil, request_id: nil

  @type t :: %__MODULE__{
          item: Plaid.Item.t(),
          income: Plaid.Income.Income.t(),
          request_id: String.t()
        }
  @type params :: %{
          required(:access_token) => String.t()
        }
  @type config :: %{required(atom) => String.t()}

  @endpoint :income

  defmodule Income do
    @moduledoc """
    Plaid.Income Income data structure.
    """

    @derive Jason.Encoder
    defstruct income_streams: [],
              last_year_income: nil,
              last_year_income_before_tax: nil,
              projected_yearly_income: nil,
              projected_yearly_income_before_tax: nil,
              max_number_of_overlapping_income_streams: nil,
              number_of_income_streams: nil

    @type t :: %__MODULE__{
            income_streams: [Plaid.Income.Income.IncomeStream.t()],
            last_year_income: Number.t(),
            last_year_income_before_tax: Number.t(),
            projected_yearly_income: Number.t(),
            projected_yearly_income_before_tax: Number.t(),
            max_number_of_overlapping_income_streams: Number.t(),
            number_of_income_streams: Number.t()
          }

    defmodule IncomeStream do
      @moduledoc """
      Plaid.Income.Income IncomeStream data structure.
      """

      @derive Jason.Encoder
      defstruct confidence: nil, days: nil, monthly_income: nil, name: nil

      @type t :: %__MODULE__{
              confidence: Number.t(),
              days: Number.t(),
              monthly_income: Number.t(),
              name: String.t()
            }
    end
  end

  @doc """
  Gets Income data associated with an Access Token.

  Parameters
  ```
  %{
    access_token: "access-env-identifier"
  }
  ```
  """
  @spec get(params, config | nil) :: {:ok, Plaid.Income.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = Map.merge(get_cred(), config)
    endpoint = "#{@endpoint}/get"

    :post
    |> make_request_with_cred(endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
