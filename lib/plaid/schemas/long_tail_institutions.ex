defmodule Plaid.LongTailInstitutions do
  @moduledoc false
  defstruct [:id, :name, :products, :forgottenPassword, :accountLocked, :accountSetup, :fields, :type]
end

defmodule Plaid.LongTailInstitutions.Products do
  @moduledoc false
  defstruct [:auth, :connect, :balance, :info, :risk, :income]
end

defmodule Plaid.LongTailInstitutions.Fields do
  @moduledoc false
  defstruct [:name, :label, :type]
end
