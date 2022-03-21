defmodule Plaid.Categories do
  @moduledoc """
  Functions for Plaid `categories` endpoint.
  """

  @derive Jason.Encoder
  defstruct categories: [], request_id: nil

  @type t :: %__MODULE__{categories: [Plaid.Categories.Category.t()], request_id: String.t()}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | PlaidHTTP.Error.t()}

  @endpoint :categories

  defmodule Category do
    @moduledoc """
    Plaid Category data structure.
    """

    @derive Jason.Encoder
    defstruct category_id: nil, hierarchy: [], group: nil
    @type t :: %__MODULE__{category_id: String.t(), hierarchy: list, group: String.t()}
  end

  @doc """
  Gets all categories.
  """
  @spec get(config) :: {:ok, Plaid.Categories.t()} | error
  def get(config \\ %{}) do
    client = config[:client] || Plaid
    config = Map.drop(config, [:public_key, :client_id, :secret])

    :post
    |> client.make_request("#{@endpoint}/get", %{}, config)
    |> client.handle_response(@endpoint, config)
  end
end
