# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-11-17

Covers every operation in Asaas's public API reference. Each new method forwards
`api_key`, `retryable`, `timeout` and, on mutating calls, `idempotency_key`.

### Added
- `LeanPayment` (`/lean/payments`), `Escrow`, `FiscalInfo`, `CreditBureauReport` and
  `MobilePhoneRecharge` resources.
- Payment: `refunds`, `refund_bank_slip`, `pay_with_card`, `pay_with_credit_card`,
  `receive_in_cash`, `undo_received_in_cash`, `billing_info`, `viewing_info`, `status`,
  `identification_field`, `simulate`, `limits`, `chargeback`, `escrow`,
  `contractual_effect_restrictions` and payment documents (`upload_document`, `documents`,
  `retrieve_document`, `update_document`, `delete_document`).
- Pix: `retrieve_key`, `find_external_key`, `token_bucket`, `delete_qr_code`, `pay_qr_code`,
  `cancel_transaction` and recurring transactions (`recurrings`, `retrieve_recurring`,
  `cancel_recurring`, `recurring_items`, `cancel_recurring_item`).
- PixAutomatic: `payment_instructions`, `retrieve_payment_instruction`,
  `retry_payment_instruction`.
- Installment: `payments`, `cancel_payments`, `refund`, `payment_book`. Subscription:
  `update_credit_card`, `payment_book`, `invoices` and invoice settings.
- PaymentLink images and `restore`; `Checkout.cancel`; credit card pre-authorization config;
  Anticipation `cancel`, `limits` and automatic configuration; Dunning `simulate`, `cancel`,
  `history`, `partial_payments`, `payments_available`; Invoice `authorize` and `cancel`;
  BillPayment `simulate` and `cancel`; `Finance.split_statistics`.
- MyAccount: `account_number`, `fees`, `wallets`, payment checkout config and
  `delete_white_label`. Subaccount access tokens (`create_access_token`, `access_tokens`,
  `update_access_token`, `delete_access_token`) and `resend_activation_link`.
  Document: `retrieve_file`, `update_file`.
- `Client#request` takes `raw: true` and returns the body as a binary String, for the PDF
  payment books.

### Fixed
These methods called paths the API doesn't have and always failed:
- `Payment.capture` now calls `/captureAuthorizedPayment` (was `/capture`).
- `Payment.confirm_cash_receipt` calls `/receiveInCash` and `Payment.payment_info` calls
  `/billingInfo`; both are now aliases of `receive_in_cash` and `billing_info`.
- `Chargeback.dispute` calls `/chargebacks/:id/dispute` (was `/disputes`).
- `Notification.update_batch` calls `PUT /notifications/batch` (was `/notifications`).
- `Webhook.remove_penalty` calls `/removeBackoff` (was `/removePenalty`); `remove_backoff`
  is the new name.
- `Subaccount.create_api_key` and `api_keys` call `/accounts/:id/accessTokens` (was
  `/apiKeys`); they are now aliases of `create_access_token` and `access_tokens`.
- README examples used `Asaas::Payment` and friends, which don't exist; they now use
  `Asaas::Resources::Payment`.

## [0.1.1] - 2026-11-12

### Added
- `Transfer.cancel(id, opts)` calls `DELETE /transfers/:id/cancel`. `Transfer.delete`
  hits `/transfers/:id`, which isn't the cancel endpoint.

### Fixed
- `update`, `delete`, `list`, `Finance.balance`, `Finance.statistics` and
  `Finance.extract` now forward the per-call `retryable` and `timeout` options.
  `ListObject#next_page` keeps them, so `auto_paging_each` honours them on every page.

## [0.1.0] - 2026-11-11

First public release, published as `asaas-sdk`. The Ruby namespace is `Asaas`;
both `require "asaas-sdk"` and `require "asaas"` load the SDK.

### Added
- `AsaasObject` with dot-access and recursive hash conversion
- `ListObject` with `auto_paging_each` for transparent pagination
- `Resources::Base` with generic CRUD (`create`, `retrieve`, `update`, `delete`, `list`)
- `HasClient` module for shared HTTP client access
- Resources: Customer, Payment, Subscription, Webhook
- Resources: Finance (`balance`, `statistics`, `extract`), Pix, PaymentLink, Transfer, Installment
- Resources: Checkout, Invoice, Split, Anticipation, Notification
- Resources: Dunning, Chargeback, Subaccount, BillPayment, PixAutomatic
- Resources: Document (KYC `/myAccount/documents` — `pending`, `send_document`, `delete_file`), MyAccount (`status`)
- Per-call options (`api_key`, retry, timeout, `idempotency_key`), including on `Payment.refund`
- Error hierarchy with HTTP status mapping (`AuthenticationError`, `NotFoundError`, `RateLimitError`, `ServerError`, `ConnectionError`)
- Automatic retry with exponential backoff on 5xx and network errors
- Idempotency key on mutating requests (POST, PUT, PATCH)
- Optional logger support

[Unreleased]: https://github.com/JoaoPierre/asaas-ruby/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/JoaoPierre/asaas-ruby/releases/tag/v0.1.0
