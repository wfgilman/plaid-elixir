defmodule Plaid.Categories do
  @moduledoc """
  Functions for Plaid `categories` endpoint.
  """

  alias Plaid.Client.Request
  alias Plaid.Client

  @derive Jason.Encoder
  defstruct categories: [], request_id: nil

  @type t :: %__MODULE__{categories: [Plaid.Categories.Category.t()], request_id: String.t()}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

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
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "categories/get")
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_categories(&1))
  end

  defp map_categories(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.Categories{
          categories: [
            %Plaid.Categories.Category{}
          ]
        }
      }
    )
  end
end
