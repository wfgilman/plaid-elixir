defmodule Plaid.Utilities do
  @moduledoc """
  Utility functions for Plaid.
  """

  alias Plaid.{Account, Connect, Error, Institutions, LongTailInstitutions, Mfa,
              Message, Transaction, TransactionType, Token}
  alias Plaid.Account.Balance, as: AccountBalance
  alias Plaid.Account.Meta, as: AccountMeta
  alias Plaid.Institutions.Credentials, as: InstitutionsCredentials
  alias Plaid.LongTailInstitutions.Fields, as: LongTailInstitutionsFields
  alias Plaid.LongTailInstitutions.Products, as: LongTailInstitutionsProducts
  alias Plaid.Mfa.Question, as: MfaQuestion
  alias Plaid.Mfa.Mask, as: MfaMask
  alias Plaid.Transaction.Meta, as: TransactionMeta
  alias Plaid.Transaction.Meta.Location, as: TransactionMetaLocation
  alias Plaid.Transaction.Meta.Location.Coordinates, as: TransactionMetaLocationCoordinates
  alias Plaid.Transaction.Score, as: TransactionScore
  alias Plaid.Transaction.Score.Location, as: TransactionScoreLocation

  @doc """
  Encodes parameters for HTTP request body.

  Merges Plaid credentials with supplied parameters and encodes the result
  for submission as the HTTP request body.

  Returns string.

  ## Example
  ```
  params = %{username: "plaid_test", password: "plaid_good", type: "wells",
             options: %{webhook: "http://requestb.in/", login_only: true,
             pending: true, list: true, start_date: "2015-01-01",
             end_date: "2015-03-31"}}
  cred = %{client_id: "test_id", secret: "test_secret"}

  "username=plaid_test&password=plaid_good&..." = Plaid.Utilities.encode_params(params, cred)
  ```
  """
  @spec encode_params(map, map) :: binary
  def encode_params(params, cred \\ %{}) do
    params
    |> Map.merge(cred)
    |> Map.to_list
    |> Enum.map_join("&", fn x -> pair(x) end)
  end

  @doc """
  Handles Plaid response.

  Routes success responses to the decoder which explicitly maps them to
  pre-defined structs based on the schema (provided as a parameter).
  Unsuccessful responses are mapped to the Plaid.Error struct.

  Returns a Plaid data struct or `HTTPoison.Error` struct.

  ## Example
  ```
  {:ok, "test_bofa"} = Plaid.Utilities.handle_plaid_response(%HTTPoison.Response{body: "{...}"}, :token)
  ```
  """
  @spec handle_plaid_response({atom, any}, atom) :: {atom, any}
  def handle_plaid_response({:error, httpoison_error}, _schema), do: {:error, httpoison_error}

  @spec handle_plaid_response(map, atom) :: {atom, binary | map}
  def handle_plaid_response(response, schema) do
    cond do
      response.status_code in [200,201] ->
        {:ok, decode_response(response.body, schema)}
      true ->
        {:error, Poison.decode!(response.body, as: %Error{})}
    end
  end


  # Maps the HTTP response body to the corresponding schema based on the schema
  # and HTTP response body format.
  defp decode_response(body, schema) do
    case schema do
      :token ->
        Poison.decode!(body, as: %Token{}) |> Map.get(:access_token)
      :connect ->
        case Poison.decode!(body) do
          %{"access_token" => _, "accounts" => _, "transactions" => _} ->
            map_transactions(body)
          %{"access_token" => _, "accounts" => _} ->
            map_accounts(body)
          %{"access_token" => _, "mfa" => [%{"question" => _}|_], "type" => _} ->
            map_mfa_question(body)
          %{"access_token" => _, "mfa" => [%{"mask" => _, "type" => _}|_], "type" => _} ->
            map_mfa_mask(body)
          %{"access_token" => _, "mfa" => %{"message" => _}, "type" => _} ->
            map_mfa_message(body)
          %{"message" => _} ->
            map_message(body)
        end
      :categories ->
        case Poison.decode!(body) do
          [_|_] ->
            Poison.decode!(body, as: [%Plaid.Categories{}])
          _ ->
            Poison.decode!(body, as: %Plaid.Categories{})
        end
      :institutions ->
        case Poison.decode!(body) do
          [_|_] ->
            map_institutions(body)
          _ ->
            map_institution(body)
        end
      :long_tail ->
        case Poison.decode!(body) do
          [] ->
            []
          [_|_] ->
            map_long_tail_institutions(body)
          _ ->
            map_long_tail_institution(body)
        end

    end
  end

  # Separates map key-value pairs into encoded strings to form the HTTP
  # request body.
  defp pair({key, value}) do
    param_name = to_string(key) |> URI.encode_www_form
    param_value =
      cond do
        is_map(value) ->
          param_value = value |> Poison.encode!
        true ->
          param_value = to_string(value) |> URI.encode_www_form
      end
    "#{param_name}=#{param_value}"
  end

  defp map_transactions(body) do
    Poison.decode!(body, as: %Connect{
      accounts: [%Account{
        balance: %AccountBalance{},
        meta: %AccountMeta{}}],
      transactions: [%Transaction{
        meta: %TransactionMeta{
          location: %TransactionMetaLocation{
            coordinates: %TransactionMetaLocationCoordinates{}}},
        type: %TransactionType{},
        score: %TransactionScore{
          location: %TransactionScoreLocation{}}}]
      })
  end

  defp map_accounts(body) do
    Poison.decode!(body, as: %Connect{
      accounts: [%Account{
        balance: %AccountBalance{},
        meta: %AccountMeta{}}]
      })
  end

  defp map_mfa_question(body) do
    Poison.decode!(body, as: %Mfa{mfa: [%MfaQuestion{}]})
  end

  defp map_mfa_mask(body) do
    Poison.decode!(body, as: %Mfa{mfa: [%MfaMask{}]})
  end

  defp map_mfa_message(body) do
    Poison.decode!(body, as: %Mfa{mfa: %Message{}})
  end

  defp map_message(body) do
    Poison.decode!(body, as: %Message{})
  end

  defp map_institutions(body) do
    Poison.decode!(body, as: [%Institutions{credentials: %InstitutionsCredentials{}}])
  end

  defp map_institution(body) do
    Poison.decode!(body, as: %Institutions{credentials: %InstitutionsCredentials{}})
  end

  defp map_long_tail_institutions(body) do
    Poison.decode!(body, as: [%LongTailInstitutions{
      products: %LongTailInstitutionsProducts{},
      fields: [%LongTailInstitutionsFields{}]
      }])
  end

  defp map_long_tail_institution(body) do
    Poison.decode!(body, as: %LongTailInstitutions{
      products: %LongTailInstitutionsProducts{},
      fields: [%LongTailInstitutionsFields{}]
      })
  end
end
