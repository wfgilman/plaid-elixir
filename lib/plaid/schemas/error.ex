defmodule Plaid.Error do
  defstruct [:access_token, :code, :message, :resolve]
end
