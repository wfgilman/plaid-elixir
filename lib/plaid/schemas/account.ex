defmodule Plaid.Account do
  @moduledoc false
  defstruct [:_id, :_item, :_user, :balance, :institution_type, :meta, :subtype, :type]
end

defmodule Plaid.Account.Balance do
  @moduledoc false
  defstruct [:available, :current]
end

defmodule Plaid.Account.Meta do
  @moduledoc false
  defstruct [:limit, :name, :number, :official_name]
end
