# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `AsaasObject` with dot-access and recursive hash conversion
- `ListObject` with `auto_paging_each` for transparent pagination
- `Resources::Base` with generic CRUD (`create`, `retrieve`, `update`, `delete`, `list`)
- `HasClient` module for shared HTTP client access
- Resources: Customer, Payment, Subscription, Webhook
- Resources: Finance, Pix, PaymentLink, Transfer, Installment
- Resources: Checkout, Invoice, Split, Anticipation, Notification
- Resources: Dunning, Chargeback, Subaccount, BillPayment, PixAutomatic
- Resources: Document (KYC `/myAccount/documents` — `pending`, `send_document`, `delete_file`), MyAccount (`status`)
- Error hierarchy with HTTP status mapping (`AuthenticationError`, `NotFoundError`, `RateLimitError`, `ServerError`, `ConnectionError`)
- Automatic retry with exponential backoff on 5xx and network errors
- Idempotency key on mutating requests (POST, PUT, PATCH)
- Optional logger support

## [0.1.0] - 2026-05-22

- Initial release
