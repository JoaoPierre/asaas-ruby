# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
