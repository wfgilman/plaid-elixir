defmodule Plaid.Utilities do
  @moduledoc """
  Utility functions for Plaid.
  """

  alias Plaid.{Account, Connect, Error, Message, Question, Mask, Transaction, TransactionType, Token}
  alias Plaid.Account.Balance, as: AccountBalance
  alias Plaid.Account.Meta, as: AccountMeta
  alias Plaid.Mfa.Message, as: MfaMessage
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
  cred = %{client_id: "test_id", secret: "test_secret"}
  params = %{username: "plaid_test", password: "plaid_good", type: "wells",
             options: %{webhook: "http://requestb.in/", login_only: true,
             pending: true, list: true, start_date: "2015-01-01",
             end_date: "2015-03-31"}}

  "username=plaid_test&password=plaid_good&..." = Plaid.Utilities.encode_params(cred, params)
  ```
  """
  @spec encode_params(map, map) :: binary
  def encode_params(cred, params) do
    cred
    |> Map.merge(params)
    |> Map.to_list
    |> Enum.map_join("&", fn x -> pair(x) end)
  end

  @doc """
  Handles Plaid response.

  Routes success responses to the decoder which maps them to pre-defined structs
  based on the schema provided as an `atom`. Unsuccessful responses are mapped to
  the Plaid.Error struct.

  Returns `Plaid.Connect`, `Plaid.Mfa`, `Plaid.Message` or `Plaid.Error` struct.

  ## Example
  ```
  {:ok, "test_bofa"} = Plaid.Utilities.handle_plaid_response(%HTTPoison.Response{body: "{...}"}, :token)
  ```
  """
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

  # Decodes Plaid response body into struct for accounts and transactions.
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

  # Decodes Plaid response body into struct for accounts only.
  defp map_accounts(body) do
    Poison.decode!(body, as: %Connect{
      accounts: [%Account{
        balance: %AccountBalance{},
        meta: %AccountMeta{}}]
      })
  end

  # Decodes Plaid response body into struct for MFA question request.
  defp map_mfa_question(body) do
    Poison.decode!(body, as: %MfaQuestion{mfa: [%Question{}]})
  end

  # Decodes Plaid response body into struct for MFA mask message.
  defp map_mfa_mask(body) do
    Poison.decode!(body, as: %MfaMask{mfa: [%Mask{}]})
  end

  # Decodes Plaid response body into struct for MFA message.
  defp map_mfa_message(body) do
    Poison.decode!(body, as: %MfaMessage{mfa: %Message{}})
  end

  # Decodes Plaid response body into struct for message reponses.
  defp map_message(body) do
    Poison.decode!(body, as: %Message{})
  end
end
