defmodule Plaid.Error do
  @moduledoc false

  defstruct error_type: nil, error_code: nil, error_message: nil,
            display_message: nil, request_id: nil, http_code: nil

  @type t :: %__MODULE__{error_type: String.t,
                         error_code: String.t,
                         error_message: String.t,
                         display_message: String.t,
                         request_id: String.t,
                         http_code: integer
                        }
end
