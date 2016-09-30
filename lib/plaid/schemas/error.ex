defmodule Plaid.Error do
  @moduledoc false
  defstruct [:access_token, :code, :message, :resolve]
end
