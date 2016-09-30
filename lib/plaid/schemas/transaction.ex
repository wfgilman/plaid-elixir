defmodule Plaid.Transaction do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :_account, :string
    field :_id, :string
    field :amount, :decimal
    field :date, :string # Ecto.Date
    field :name, :string
    embeds_one :meta, Plaid.Transaction.Meta
    field :pending, :boolean
    embeds_one :type, Plaid.TransactionType
    field :category, {:array, :string}
    field :category_id, :string
    embeds_one :score, Plaid.Transaction.Score
  end
end

defmodule Plaid.Transaction.Meta do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    embeds_one :location, Plaid.Transaction.Meta.Location
    field :contact, :string
  end
end

defmodule Plaid.Transaction.Meta.Location do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :address, :string
    field :city, :string
    embeds_one :coordinates, Plaid.Transaction.Meta.Location.Coordinates
    field :state, :string
    field :store_number, :string
    field :zip, :string
  end
end

defmodule Plaid.Transaction.Meta.Location.Coordinates do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :lat, :float
    field :lon, :float
  end
end

defmodule Plaid.TransactionType do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :primary, :string
  end
end

defmodule Plaid.Transaction.Score do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    embeds_one :location, Plaid.Transaction.Score.Location
    field :name, :float
  end
end

defmodule Plaid.Transaction.Score.Location do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :address, :float
    field :city, :float
    field :state, :float
    field :zip, :float
  end
end
