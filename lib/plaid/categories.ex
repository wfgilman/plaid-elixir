defmodule Plaid.Categories do
  @moduledoc """
  Functions for working with Plaid Categories.

  * Return all categories
  * Fetch a category by id

  This endpoint requires no authentication.

  Plaid API Reference: https://plaid.com/docs/api/#categories
  """

  alias Plaid.Utilities

  defstruct [:hierarchy, :id, :type]

  @endpoint "categories"

  @doc """
  Returns all Plaid categories.

  Returns the universe of Plaid categories in it's current state. Category
  taxnomy is updated periodically, so refreshing data cached locally is useful.

  Returns a list of `Plaid.Categories` or `Plaid.Error` struct.

  ## Example
  ```
  {:ok, [%Plaid.Categories{...}]} = Plaid.Categories.all()
  {:error, %Plaid.Error{...}} = Plaid.Categories.all()
  ```
  Plaid API Reference: https://plaid.com/docs/api/#all-categories
  """
  @spec all() :: {atom, list}
  def all() do
    Plaid.make_request(:get, @endpoint)
    |> Utilities.handle_plaid_response(:categories)
  end

  @doc """
  Fetches a Plaid category based on the id.

  Returns a specific Plaid category by category id provided. This function
  accepts the id as an integer or string. Useful for returning data about the
  category based on the id returned in the transactions from the Connect endpoint.

  Returns a `Plaid.Categories` struct.

  ## Example
  ```
  {:ok, %Plaid.Categories{...}} = Plaid.Categories.id("12015002")
  {:error, %Plaid.Error{...}} = Plaid.Categories.id("12015002")
  ```
  Plaid API Reference: https://plaid.com/docs/api/#categories-by-id
  """
  @spec id(integer | binary) :: {atom, map}
  def id(id) do
    id =
      case is_integer(id) do
        true ->
          Integer.to_string(id)
        _ ->
          id
      end
    endpoint = @endpoint <> "/" <> id
    Plaid.make_request(:get, endpoint)
    |> Utilities.handle_plaid_response(:categories)
  end

end
