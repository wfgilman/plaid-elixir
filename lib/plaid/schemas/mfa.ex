defmodule Plaid.Mfa do
  @moduledoc false
  defstruct [:access_token, :mfa, :type]
end

defmodule Plaid.Mfa.Mask do
  @moduledoc false
  defstruct [:mask, :type]
end

defmodule Plaid.Mfa.Question do
  @moduledoc false
  defstruct [:question]
end
