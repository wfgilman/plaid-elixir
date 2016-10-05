defmodule Plaid.Transaction do
  @moduledoc false
  defstruct [:_account, :_id, :amount, :date, :name, :meta, :pending, :type, :category, :category_id, :score]
end

defmodule Plaid.Transaction.Meta do
  @moduledoc false
  defstruct [:location, :contact]
end

defmodule Plaid.Transaction.Meta.Location do
  @moduledoc false
  defstruct [:address, :city, :coordinates, :state, :store_number, :zip]
end

defmodule Plaid.Transaction.Meta.Location.Coordinates do
  @moduledoc false
  defstruct [:lat, :lon]
end

defmodule Plaid.TransactionType do
  @moduledoc false
  defstruct [:primary]
end

defmodule Plaid.Transaction.Score do
  @moduledoc false
  defstruct [:location, :name]
end

defmodule Plaid.Transaction.Score.Location do
  @moduledoc false
  defstruct [:address, :city, :state, :zip]
end
