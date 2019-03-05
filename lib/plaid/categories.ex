defmodule Plaid.Categories do
  @moduledoc """
  Functions for Plaid `categories` endpoint.
  """

  @derive Jason.Encoder
  defstruct categories: [], request_id: nil

  @type t :: %__MODULE__{categories: [Plaid.Categories.Category.t],
                         request_id: String.t}

  @endpoint :categories

  defmodule Category do
    @moduledoc """
    Plaid Category data structure.
    """

    @derive Jason.Encoder
    defstruct category_id: nil, hierarchy: [], group: nil
    @type t :: %__MODULE__{category_id: String.t,
                           hierarchy: list,
                           group: String.t}
  end

  @doc """
  Gets all categories.
  """
  @spec get() :: {:ok, Plaid.Categories.t} | {:error, Plaid.Error.t}
  def get do
    endpoint = "#{@endpoint}/get"
    Plaid.make_request(:post, endpoint)
    |> Plaid.Utils.handle_resp(@endpoint)
  end

end
