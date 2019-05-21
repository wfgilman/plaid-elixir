defmodule Plaid.Categories do
  @moduledoc """
  Functions for Plaid `categories` endpoint.
  """

  @derive Jason.Encoder
  defstruct categories: [], request_id: nil

  @type t :: %__MODULE__{categories: [Plaid.Categories.Category.t()], request_id: String.t()}
  @type config :: %{required(atom) => String.t()}

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
  @spec get(config | nil) :: {:ok, Plaid.Categories.t()} | {:error, Plaid.Error.t()}
  def get(config \\ %{}) do
    config = Map.drop(config, [:public_key, :client_id, :secret])
    endpoint = "#{@endpoint}/get"

    Plaid.make_request_with_cred(:post, endpoint, config)
    |> Plaid.Utils.handle_resp(@endpoint)
  end
end
