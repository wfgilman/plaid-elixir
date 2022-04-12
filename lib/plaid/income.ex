defmodule Plaid.Income do
  @moduledoc """
  Functions for Plaid `income` endpoint.
  """

  alias Plaid.Client.Request
  alias Plaid.Client

  @derive Jason.Encoder
  defstruct item: nil, income: nil, request_id: nil

  @type t :: %__MODULE__{
          item: Plaid.Item.t(),
          income: Plaid.Income.Income.t(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

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
            last_year_income: float(),
            last_year_income_before_tax: float(),
            projected_yearly_income: float(),
            projected_yearly_income_before_tax: float(),
            max_number_of_overlapping_income_streams: float(),
            number_of_income_streams: float()
          }

    defmodule IncomeStream do
      @moduledoc """
      Plaid.Income.Income IncomeStream data structure.
      """

      @derive Jason.Encoder
      defstruct confidence: nil, days: nil, monthly_income: nil, name: nil

      @type t :: %__MODULE__{
              confidence: float(),
              days: integer(),
              monthly_income: float(),
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
  @spec get(params, config) :: {:ok, Plaid.Income.t()} | error
  def get(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "income/get", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_income(&1))
  end

  defp map_income(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.Income{
          item: %Plaid.Item{},
          income: %Plaid.Income.Income{
            income_streams: [
              %Plaid.Income.Income.IncomeStream{}
            ]
          }
        }
      }
    )
  end
end
