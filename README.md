# asaas-sdk

Ruby SDK for the [Asaas](https://www.asaas.com) payment gateway API.

## Installation

Add to your Gemfile:

```ruby
gem "asaas-sdk"
```

Or install directly:

```bash
gem install asaas-sdk
```

Until the first release is on RubyGems, install from GitHub:

```ruby
gem "asaas-sdk", github: "JoaoPierre/asaas-ruby"
```

The gem is published as `asaas-sdk`, but the namespace is `Asaas`
(`Asaas.configure`, `Asaas::Resources::Payment`, ...).

## Configuration

```ruby
Asaas.configure do |c|
  c.api_key  = "your_api_key"
  c.sandbox  = true   # false in production
end
```

| Option | Default | Description |
|---|---|---|
| `api_key` | `nil` | Your Asaas API key |
| `sandbox` | `false` | Use sandbox environment |
| `timeout` | `30` | HTTP timeout in seconds |
| `max_retries` | `2` | Retries on 5xx / network errors |
| `retry_delay` | `0.5` | Base delay in seconds (exponential backoff) |
| `logger` | `nil` | Any Logger-compatible object |

### Per-call API key

Every resource method accepts a final positional options hash that overrides the global `api_key` — useful for multi-tenant apps and subaccount keys. When passing options, the `params` hash must be explicit.

```ruby
Asaas::Resources::Customer.retrieve("cus_123", api_key: "aact_subaccount_key")
Asaas::Resources::Customer.list({ name: "João" }, api_key: "aact_subaccount_key")
Asaas::Resources::Payment.create(
  { customer: "cus_123", value: 10.0, billingType: "PIX", dueDate: "2025-12-31" },
  api_key: "aact_subaccount_key"
)
Asaas::Resources::Finance.balance(api_key: "aact_subaccount_key")
```

### Stable idempotency keys for creates

`Base.create` resources accept `idempotency_key:` in the final options hash.
It is sent only as the `Idempotency-Key` HTTP header, and the same value is
preserved if the request is retried. The key must be a non-blank `String`.

```ruby
Asaas::Resources::Customer.create(
  { name: "João Silva", email: "joao@example.com" },
  idempotency_key: "scoby-customer-42"
)
```

`ListObject` pages returned with an override keep that override when paginated:

```ruby
list = Asaas::Resources::Customer.list({ limit: 50 }, api_key: "aact_subaccount_key")
list.next_page  # also uses aact_subaccount_key
```

For direct `Client` usage:

```ruby
client = Asaas::Client.new(api_key: "aact_subaccount_key")
client.request(:get, "/customers")
```

## Usage

All resources return `AsaasObject` instances with dot-access to attributes. List endpoints return `ListObject`, which supports pagination.

### Customers

```ruby
customer = Asaas::Resources::Customer.create(name: "João Silva", cpfCnpj: "000.000.000-00", email: "joao@example.com")
customer.id       # => "cus_..."
customer.name     # => "João Silva"

Asaas::Resources::Customer.retrieve("cus_123")
Asaas::Resources::Customer.update("cus_123", name: "João Atualizado")
Asaas::Resources::Customer.delete("cus_123")
Asaas::Resources::Customer.restore("cus_123")
Asaas::Resources::Customer.list(name: "João")
Asaas::Resources::Customer.notifications("cus_123")
```

### Payments

```ruby
payment = Asaas::Resources::Payment.create(
  customer:    "cus_123",
  billingType: "PIX",
  value:       150.0,
  dueDate:     "2025-12-31"
)

Asaas::Resources::Payment.retrieve("pay_123")
Asaas::Resources::Payment.update("pay_123", value: 200.0)
Asaas::Resources::Payment.delete("pay_123")
Asaas::Resources::Payment.restore("pay_123")
Asaas::Resources::Payment.list(status: "PENDING")
Asaas::Resources::Payment.refund("pay_123", value: 150.0)
Asaas::Resources::Payment.capture("pay_123")  # pre-authorized card payment
Asaas::Resources::Payment.receive_in_cash("pay_123", paymentDate: "2025-01-15", value: 100.0)
Asaas::Resources::Payment.undo_received_in_cash("pay_123")
Asaas::Resources::Payment.billing_info("pay_123")
Asaas::Resources::Payment.status("pay_123")
Asaas::Resources::Payment.identification_field("pay_123")  # boleto line
Asaas::Resources::Payment.pay_with_card("pay_123", cardType: "CREDIT", cardToken: "tok_123")
Asaas::Resources::Payment.refunds("pay_123")
Asaas::Resources::Payment.refund_bank_slip("pay_123")
Asaas::Resources::Payment.simulate(value: 100.0, installmentCount: 3, billingTypes: ["CREDIT_CARD"])
Asaas::Resources::Payment.documents("pay_123")

# Same API with a summarized response body
Asaas::Resources::LeanPayment.create(customer: "cus_123", billingType: "PIX", value: 100.0, dueDate: "2025-12-31")
```

`Payment.refund(id, params, opts)` also accepts per-call `retryable`, `timeout`
and `idempotency_key` options, alongside `api_key`. Existing calls keep the
configured retry policy by default. For a financial operation that must not be
automatically repeated after an ambiguous response, set `retryable: false` and
reconcile the payment before any new refund submission. Passing an idempotency
key forwards the header; it does not by itself prove provider-side deduplication.

The generic `create`, `retrieve`, `update`, `delete` and `list` (including the
pages `auto_paging_each` fetches), `Finance.balance`, `Finance.statistics`,
`Finance.extract` and `Transfer.cancel` accept the same `retryable` and
`timeout` options. So does every endpoint added in 0.2.0, and its
mutating calls also take `idempotency_key` (pass a stable one on
`Pix.pay_qr_code`, which moves money out of the account).

### Subscriptions

```ruby
subscription = Asaas::Resources::Subscription.create(
  customer:    "cus_123",
  billingType: "PIX",
  value:       49.90,
  cycle:       "MONTHLY",
  nextDueDate: "2025-02-01"
)

Asaas::Resources::Subscription.retrieve("sub_123")
Asaas::Resources::Subscription.update("sub_123", value: 59.90)
Asaas::Resources::Subscription.delete("sub_123")
Asaas::Resources::Subscription.list
Asaas::Resources::Subscription.payments("sub_123")
```

### Pix

```ruby
Asaas::Resources::Pix.create_key(type: "EMAIL", key: "joao@example.com")
Asaas::Resources::Pix.list_keys
Asaas::Resources::Pix.delete_key("key_123")

qr = Asaas::Resources::Pix.create_qr_code(addressKey: "joao@example.com", value: 50.0)
qr.payload    # => "00020101..."

Asaas::Resources::Pix.transactions(type: "CREDIT")
Asaas::Resources::Pix.decode_qr_code(payload: "00020101...")
```

### Finance

```ruby
balance = Asaas::Resources::Finance.balance
balance.balance  # => 1500.0

Asaas::Resources::Finance.statistics(billingType: "PIX")

# Account statement (GET /financialTransactions), paginated
Asaas::Resources::Finance.extract(startDate: "2026-11-01", finishDate: "2026-11-30", order: "desc")
```

### Payment Links

```ruby
link = Asaas::Resources::PaymentLink.create(name: "Produto X", value: 99.90, billingType: "UNDEFINED")
Asaas::Resources::PaymentLink.retrieve("lnk_123")
Asaas::Resources::PaymentLink.update("lnk_123", value: 149.90)
Asaas::Resources::PaymentLink.delete("lnk_123")
Asaas::Resources::PaymentLink.list
Asaas::Resources::PaymentLink.add_image("lnk_123", image: "base64data")
```

### Transfers

```ruby
Asaas::Resources::Transfer.create(value: 500.0, walletId: "wal_abc")
Asaas::Resources::Transfer.retrieve("tra_123")
Asaas::Resources::Transfer.list
Asaas::Resources::Transfer.cancel("tra_123")  # DELETE /transfers/:id/cancel
```

### Installments

```ruby
Asaas::Resources::Installment.create(customer: "cus_123", value: 1200.0, installmentCount: 12, billingType: "CREDIT_CARD")
Asaas::Resources::Installment.retrieve("ins_123")
Asaas::Resources::Installment.list
Asaas::Resources::Installment.delete("ins_123")
Asaas::Resources::Installment.update_splits("ins_123", splits: [{ walletId: "wal_1", percentualValue: 10.0 }])
```

### Webhooks

```ruby
Asaas::Resources::Webhook.create(url: "https://example.com/webhook", email: "dev@example.com")
Asaas::Resources::Webhook.retrieve("web_123")
Asaas::Resources::Webhook.update("web_123", url: "https://example.com/new")
Asaas::Resources::Webhook.delete("web_123")
Asaas::Resources::Webhook.list
Asaas::Resources::Webhook.remove_backoff("web_123")
```

### Notifications

```ruby
Asaas::Resources::Notification.update("not_123", enabled: false)
Asaas::Resources::Notification.update_batch(notifications: [{ id: "not_123", enabled: true }])
```

### Invoices

```ruby
Asaas::Resources::Invoice.create(payment: "pay_123", serviceDescription: "Consultoria")
Asaas::Resources::Invoice.retrieve("inv_123")
Asaas::Resources::Invoice.update("inv_123", serviceDescription: "Desenvolvimento")
Asaas::Resources::Invoice.delete("inv_123")
Asaas::Resources::Invoice.list
```

### Anticipations

```ruby
Asaas::Resources::Anticipation.simulate(payment: "pay_123")
Asaas::Resources::Anticipation.create(payment: "pay_123")
Asaas::Resources::Anticipation.retrieve("ant_123")
Asaas::Resources::Anticipation.list
Asaas::Resources::Anticipation.delete("ant_123")  # cancel
```

### Splits

```ruby
Asaas::Resources::Split.paid
Asaas::Resources::Split.received
Asaas::Resources::Split.retrieve_paid("spl_123")
Asaas::Resources::Split.retrieve_received("spl_123")
```

### Checkouts

```ruby
Asaas::Resources::Checkout.create(billingType: "UNDEFINED", totalValue: 150.0)
Asaas::Resources::Checkout.retrieve("chk_123")
Asaas::Resources::Checkout.delete("chk_123")  # cancel
```

### Dunning

```ruby
Asaas::Resources::Dunning.create(payment: "pay_123", type: "CREDIT_BUREAU")
Asaas::Resources::Dunning.retrieve("dun_123")
Asaas::Resources::Dunning.list
Asaas::Resources::Dunning.delete("dun_123")  # cancel
Asaas::Resources::Dunning.resend_documents("dun_123")
```

### Chargebacks

```ruby
Asaas::Resources::Chargeback.list
Asaas::Resources::Chargeback.retrieve("cbk_123")
Asaas::Resources::Chargeback.dispute("cbk_123", description: "Item entregue conforme pedido")
```

### Subaccounts

```ruby
Asaas::Resources::Subaccount.create(name: "Loja Parceira", email: "loja@example.com", cpfCnpj: "000.000.000-00")
Asaas::Resources::Subaccount.retrieve("sub_123")
Asaas::Resources::Subaccount.list
Asaas::Resources::Subaccount.create_access_token("sub_123", name: "production")
Asaas::Resources::Subaccount.access_tokens("sub_123")
Asaas::Resources::Subaccount.resend_activation_link("sub_123")
```

### Account Status and Commercial Info

Authoritative KYC registration status for the authenticated account. Acts on
`/myAccount`, so pass the subaccount's own key per call:

```ruby
status = Asaas::Resources::MyAccount.status(api_key: "aact_subaccount_key")
status.commercialInfo   # => "APPROVED"
status.documentation    # => "AWAITING_APPROVAL"
status.bankAccountInfo  # => "PENDING"
status.general          # => "PENDING"

commercial_info = Asaas::Resources::MyAccount.commercial_info(api_key: "aact_subaccount_key")
commercial_info.incomeValue

# POST replaces the full applicable profile; include every applicable field.
profile = {
  personType: "JURIDICA",
  cpfCnpj: "35381637000150",
  companyType: "LIMITED",
  companyName: "Loja Parceira Ltda",
  incomeValue: 50_000.0,
  email: "financeiro@lojapareceira.example",
  mobilePhone: "11999999999",
  postalCode: "01310100",
  address: "Avenida Paulista",
  addressNumber: "1000",
  province: "Bela Vista",
  site: "https://lojapareceira.example"
}
Asaas::Resources::MyAccount.update_commercial_info(profile, api_key: "aact_subaccount_key")

# Disable automatic retries for this POST if needed
Asaas::Resources::MyAccount.update_commercial_info(
  profile,
  api_key: "aact_subaccount_key",
  retryable: false
)
```

`incomeValue` is required when resubmitting commercial info. These methods act
on the authenticated account, so use that subaccount's API key.

### Documents (KYC)

KYC documents for the authenticated account (`/myAccount/documents`). Pass the
subaccount's own key per call:

```ruby
# List pending document groups (each with its onboardingUrl and sent files)
groups = Asaas::Resources::Document.pending(api_key: "aact_subaccount_key")
group  = groups.data.first
group.onboardingUrl

# Upload a file to a group (multipart). `file` is any IO that responds to #read.
Asaas::Resources::Document.send_document(
  group.id,
  file: File.open("identity.png"),
  type: "IDENTIFICATION",
  api_key: "aact_subaccount_key"
)

# Remove a previously sent file
Asaas::Resources::Document.delete_file("file_123", api_key: "aact_subaccount_key")
```

> Asaas recommends waiting ~15s after subaccount creation before listing
> documents, so Receita Federal validation can finish.

### Bill Payments

```ruby
Asaas::Resources::BillPayment.create(identificationField: "123456789", value: 150.0)
Asaas::Resources::BillPayment.retrieve("bil_123")
Asaas::Resources::BillPayment.list
Asaas::Resources::BillPayment.delete("bil_123")  # cancel
```

### Pix Automatic

```ruby
Asaas::Resources::PixAutomatic.create(customer: "cus_123", value: 99.90)
Asaas::Resources::PixAutomatic.list
Asaas::Resources::PixAutomatic.delete("aut_123")  # cancel

# Each charge an authorization schedules is a payment instruction
Asaas::Resources::PixAutomatic.payment_instructions(authorization: "aut_123")
Asaas::Resources::PixAutomatic.retry_payment_instruction("pi_123", dueDate: "2025-12-31")
```

### Escrow

```ruby
Asaas::Resources::Escrow.save_default_config(daysToExpire: 30, enabled: true)
Asaas::Resources::Escrow.save_config("acc_123", daysToExpire: 30, enabled: true)
Asaas::Resources::Payment.escrow("pay_123")
Asaas::Resources::Escrow.finish("esc_123")
```

### Fiscal Info (NFS-e setup)

```ruby
Asaas::Resources::FiscalInfo.retrieve
Asaas::Resources::FiscalInfo.municipal_options
Asaas::Resources::FiscalInfo.services(description: "1.01")
Asaas::Resources::FiscalInfo.nbs_codes
Asaas::Resources::Invoice.authorize("inv_123")
Asaas::Resources::Invoice.cancel("inv_123")
```

### Credit Bureau Reports and Mobile Recharges

```ruby
Asaas::Resources::CreditBureauReport.create(customer: "cus_123", state: "SP")
Asaas::Resources::MobilePhoneRecharge.provider("11999999999")
Asaas::Resources::MobilePhoneRecharge.create(phoneNumber: "11999999999", value: 20.0)
```

### PDF endpoints

Payment books (carnês) come back as a binary `String`:

```ruby
File.binwrite("carne.pdf", Asaas::Resources::Installment.payment_book("ins_123"))
```

## Pagination

List endpoints return a `ListObject`. You can iterate the current page or all pages automatically:

```ruby
# Current page only
payments = Asaas::Resources::Payment.list(limit: 10)
payments.each { |p| puts p.status }
payments.total_count  # => 312
payments.has_more     # => true

# All pages — fetches next automatically
Asaas::Resources::Payment.list.auto_paging_each do |payment|
  puts payment.id
end

# As an Enumerator (lazy)
Asaas::Resources::Payment.list.auto_paging_each.lazy.first(50)
```

## Error Handling

```ruby
begin
  Asaas::Resources::Customer.retrieve("invalid_id")
rescue Asaas::NotFoundError => e
  puts e.message
  puts e.http_status   # => 404
  puts e.request_id
rescue Asaas::AuthenticationError
  puts "Invalid API key"
rescue Asaas::RateLimitError
  puts "Too many requests"
rescue Asaas::AsaasError => e
  puts "Unexpected error: #{e.message}"
end
```

| Exception | HTTP Status |
|---|---|
| `AuthenticationError` | 401 |
| `PermissionError` | 403 |
| `NotFoundError` | 404 |
| `RateLimitError` | 429 |
| `ServerError` | 5xx |
| `ConnectionError` | network failure |

## Development

```bash
bundle install
bundle exec rspec       # run tests
bundle exec rubocop     # lint
bundle exec rake        # tests + lint
```

## License

MIT License. See [LICENSE.txt](LICENSE.txt).
