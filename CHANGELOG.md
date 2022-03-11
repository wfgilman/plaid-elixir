# Changelog

## v3.0

### Hard Deprecations
- `Plaid.get_cred/0` - Soft deprecated since `2.0`
- `Plaid.get_key/0` - Soft deprecated since `2.0`
- `Plaid.make_request/5` - Soft deprecated since `2.0`
- `Plaid.make_request_with_cred/6` - Replaced by `Plaid.make_request/4`
- `Plaid.Utils` - Renamed to `PlaidHandler`
- `Plaid.Utils.map_response` - Made a private function called by `PlaidHandler.handle_resp`
- `Plaid.Item.create_processor_token/3` - Replaced by `Plaid.Item.create_processor_token/2`

### Return Type Changes
- `Plaid.PaymentInitiation.Payments.create/2` - Returns `Plaid.PaymentInitiation.Payments.Payment.t` instead of `Plaid.PaymentInitiation.Payments.t`
- `Plaid.PaymentInitiation.Payments.list/2` - Returns `Plaid.PaymentInitiation.Payments.t` instead of `[Plaid.PaymentInitiation.Payments.Payment.t]`. Access the former's `payments` key instead
- `Plaid.PaymentInitiation.Recipients.create/2` - Returns `Plaid.PaymentInitiation.Recipients.Recipient.t` instead of `Plaid.PaymentInitiation.Recipients.t`
- `Plaid.PaymentInitiation.Recipients.list/1` - Returns `Plaid.PaymentInitiation.Recipients.t` instead of `[Plaid.PaymentInitiation.Recipients.Recipient.t]` Access the former's `recipients` key instead

### Struct Changes
- `Plaid.Auth` - Fixed bug causing the `numbers` key not to be set to type `Plaid.Auth.Numbers`
- `Plaid.PaymentInitiation.Payments` - Modified to remove `payment_id` and include `payments` and `next_cursor` to match library pattern for arrays returned by Plaid. Access `payment_id` in `Plaid.PaymentInitiation.Payments.Payment` instead
- `Plaid.PaymentInitiation.Payments.Payment.amount` - Changed default value to `nil` from `0`
- `Plaid.PaymentInitiation.Recipients` - Modified to remove `recipient_id` and include `recipients` to match library pattern for arrays returned by Plaid. Access `recipient_id` in `Plaid.PaymentInitiation.Recipients.Recipient` instead
- `Plaid.PaymentInitiation.Payments` - Fixed bug causing the `amount` and `schedule` keys not to be set to their respective struct types
- `Plaid.PaymentInitiation.Recipients` - Fixed bug causing the `address` key not to be set to type `Plaid.PaymentInitiation.Recipients.Recipient.Address`

### Type Changes
- `Plaid.Item` - Removed type `service` which is now passed in the `params` argument to `Plaid.Item.create_processor_token/2`

### Project Structure
- Moved all telemetry functionality to `PlaidTelemetry` for better testing
- Moved HTTP request functionality using HTTPoison to `PlaidHTTP` for better testing
- Renamed `Plaid.Utils` to `PlaidHandler`
