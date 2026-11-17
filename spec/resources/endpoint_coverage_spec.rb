# frozen_string_literal: true

require "spec_helper"

# Every endpoint added for full API coverage: the verb and path each method hits and what it returns.
# One row per method: [resource, method, args, verb, path, returns].
RSpec.describe "API endpoint coverage" do
  endpoints = [
    # Payments
    [:Payment, :refunds, ["pay_1"], :get, "/payments/pay_1/refunds", :list],
    [:Payment, :refund_bank_slip, ["pay_1"], :post, "/payments/pay_1/bankSlip/refund", :object],
    [:Payment, :pay_with_card, ["pay_1", { cardType: "CREDIT" }], :post, "/payments/pay_1/payWithCard", :object],
    [:Payment, :pay_with_credit_card, ["pay_1"], :post, "/payments/pay_1/payWithCreditCard", :object],
    [:Payment, :receive_in_cash, ["pay_1"], :post, "/payments/pay_1/receiveInCash", :object],
    [:Payment, :undo_received_in_cash, ["pay_1"], :post, "/payments/pay_1/undoReceivedInCash", :object],
    [:Payment, :billing_info, ["pay_1"], :get, "/payments/pay_1/billingInfo", :object],
    [:Payment, :viewing_info, ["pay_1"], :get, "/payments/pay_1/viewingInfo", :object],
    [:Payment, :status, ["pay_1"], :get, "/payments/pay_1/status", :object],
    [:Payment, :identification_field, ["pay_1"], :get, "/payments/pay_1/identificationField", :object],
    [:Payment, :simulate, [{ value: 100 }], :post, "/payments/simulate", :object],
    [:Payment, :limits, [], :get, "/payments/limits", :object],
    [:Payment, :chargeback, ["pay_1"], :get, "/payments/pay_1/chargeback", :object],
    [:Payment, :escrow, ["pay_1"], :get, "/payments/pay_1/escrow", :object],
    [:Payment, :contractual_effect_restrictions, ["pay_1"], :get,
     "/payments/pay_1/contractualEffectRestrictions", :object],
    [:Payment, :upload_document, ["pay_1"], :post, "/payments/pay_1/documents", :object],
    [:Payment, :documents, ["pay_1"], :get, "/payments/pay_1/documents", :list],
    [:Payment, :retrieve_document, %w[pay_1 doc_1], :get, "/payments/pay_1/documents/doc_1", :object],
    [:Payment, :update_document, %w[pay_1 doc_1], :put, "/payments/pay_1/documents/doc_1", :object],
    [:Payment, :delete_document, %w[pay_1 doc_1], :delete, "/payments/pay_1/documents/doc_1", :object],

    # Lean payments
    [:LeanPayment, :create, [{ value: 10 }], :post, "/lean/payments", :object],
    [:LeanPayment, :list, [], :get, "/lean/payments", :list],
    [:LeanPayment, :retrieve, ["pay_1"], :get, "/lean/payments/pay_1", :object],
    [:LeanPayment, :update, ["pay_1"], :put, "/lean/payments/pay_1", :object],
    [:LeanPayment, :delete, ["pay_1"], :delete, "/lean/payments/pay_1", :object],
    [:LeanPayment, :restore, ["pay_1"], :post, "/lean/payments/pay_1/restore", :object],
    [:LeanPayment, :refund, ["pay_1"], :post, "/lean/payments/pay_1/refund", :object],
    [:LeanPayment, :capture, ["pay_1"], :post, "/lean/payments/pay_1/captureAuthorizedPayment", :object],
    [:LeanPayment, :receive_in_cash, ["pay_1"], :post, "/lean/payments/pay_1/receiveInCash", :object],
    [:LeanPayment, :undo_received_in_cash, ["pay_1"], :post, "/lean/payments/pay_1/undoReceivedInCash", :object],

    # Installments and subscriptions
    [:Installment, :payments, ["ins_1"], :get, "/installments/ins_1/payments", :list],
    [:Installment, :cancel_payments, ["ins_1"], :delete, "/installments/ins_1/payments", :object],
    [:Installment, :refund, ["ins_1"], :post, "/installments/ins_1/refund", :object],
    [:Installment, :payment_book, ["ins_1"], :get, "/installments/ins_1/paymentBook", :raw],
    [:Subscription, :update_credit_card, ["sub_1"], :post, "/subscriptions/sub_1/updateCreditCard", :object],
    [:Subscription, :payment_book, ["sub_1"], :get, "/subscriptions/sub_1/paymentBook", :raw],
    [:Subscription, :invoices, ["sub_1"], :get, "/subscriptions/sub_1/invoices", :list],
    [:Subscription, :invoice_settings, ["sub_1"], :get, "/subscriptions/sub_1/invoiceSettings", :object],
    [:Subscription, :create_invoice_settings, ["sub_1"], :post, "/subscriptions/sub_1/invoiceSettings", :object],
    [:Subscription, :update_invoice_settings, ["sub_1"], :put, "/subscriptions/sub_1/invoiceSettings", :object],
    [:Subscription, :delete_invoice_settings, ["sub_1"], :delete, "/subscriptions/sub_1/invoiceSettings", :object],

    # Payment links and checkouts
    [:PaymentLink, :restore, ["lnk_1"], :post, "/paymentLinks/lnk_1/restore", :object],
    [:PaymentLink, :images, ["lnk_1"], :get, "/paymentLinks/lnk_1/images", :list],
    [:PaymentLink, :retrieve_image, %w[lnk_1 img_1], :get, "/paymentLinks/lnk_1/images/img_1", :object],
    [:PaymentLink, :delete_image, %w[lnk_1 img_1], :delete, "/paymentLinks/lnk_1/images/img_1", :object],
    [:PaymentLink, :set_main_image, %w[lnk_1 img_1], :put, "/paymentLinks/lnk_1/images/img_1/setAsMain", :object],
    [:Checkout, :cancel, ["chk_1"], :post, "/checkouts/chk_1/cancel", :object],

    # Credit card and anticipations
    [:CreditCard, :pre_authorization_config, [], :get, "/creditCard/preAuthorization/config", :object],
    [:CreditCard, :update_pre_authorization_config, [{ enabled: true }], :post,
     "/creditCard/preAuthorization/config", :object],
    [:Anticipation, :cancel, ["ant_1"], :post, "/anticipations/ant_1/cancel", :object],
    [:Anticipation, :limits, [], :get, "/anticipations/limits", :object],
    [:Anticipation, :configuration, [], :get, "/anticipations/configurations", :object],
    [:Anticipation, :update_configuration, [{ creditCardAutomaticEnabled: true }], :put,
     "/anticipations/configurations", :object],

    # Escrow and credit bureau
    [:Escrow, :default_config, [], :get, "/accounts/escrow", :object],
    [:Escrow, :save_default_config, [{ enabled: true }], :post, "/accounts/escrow", :object],
    [:Escrow, :config, ["acc_1"], :get, "/accounts/acc_1/escrow", :object],
    [:Escrow, :save_config, ["acc_1", { enabled: true }], :post, "/accounts/acc_1/escrow", :object],
    [:Escrow, :finish, ["esc_1"], :post, "/escrow/esc_1/finish", :object],
    [:CreditBureauReport, :create, [{ customer: "cus_1" }], :post, "/creditBureauReport", :object],
    [:CreditBureauReport, :list, [], :get, "/creditBureauReport", :list],
    [:CreditBureauReport, :retrieve, ["rep_1"], :get, "/creditBureauReport/rep_1", :object],

    # Dunnings and invoices
    [:Dunning, :simulate, [{ payment: "pay_1" }], :post, "/paymentDunnings/simulate", :object],
    [:Dunning, :cancel, ["dun_1"], :post, "/paymentDunnings/dun_1/cancel", :object],
    [:Dunning, :history, ["dun_1"], :get, "/paymentDunnings/dun_1/history", :list],
    [:Dunning, :partial_payments, ["dun_1"], :get, "/paymentDunnings/dun_1/partialPayments", :list],
    [:Dunning, :payments_available, [], :get, "/paymentDunnings/paymentsAvailableForDunning", :list],
    [:Invoice, :authorize, ["inv_1"], :post, "/invoices/inv_1/authorize", :object],
    [:Invoice, :cancel, ["inv_1"], :post, "/invoices/inv_1/cancel", :object],

    # Fiscal info
    [:FiscalInfo, :retrieve, [], :get, "/fiscalInfo/", :object],
    [:FiscalInfo, :save, [{ email: "fiscal@example.com" }], :post, "/fiscalInfo/", :object],
    [:FiscalInfo, :configure_national_portal, [{ enabled: true }], :post, "/fiscalInfo/nationalPortal", :object],
    [:FiscalInfo, :municipal_options, [], :get, "/fiscalInfo/municipalOptions", :object],
    [:FiscalInfo, :services, [], :get, "/fiscalInfo/services", :list],
    [:FiscalInfo, :federal_service_codes, [], :get, "/fiscalInfo/federalServiceCodes", :list],
    [:FiscalInfo, :nbs_codes, [], :get, "/fiscalInfo/nbsCodes", :list],
    [:FiscalInfo, :operation_indicator_codes, [], :get, "/fiscalInfo/operationIndicatorCodes", :list],
    [:FiscalInfo, :tax_classification_codes, [], :get, "/fiscalInfo/taxClassificationCodes", :list],
    [:FiscalInfo, :tax_situation_codes, [], :get, "/fiscalInfo/taxSituationCodes", :list],

    # Pix
    [:Pix, :retrieve_key, ["key_1"], :get, "/pix/addressKeys/key_1", :object],
    [:Pix, :find_external_key, [{ key: "a@b.com" }], :get, "/pix/addressKeys/external?key=a@b.com", :object],
    [:Pix, :token_bucket, [], :get, "/pix/tokenBucket/addressKey", :object],
    [:Pix, :delete_qr_code, ["qr_1"], :delete, "/pix/qrCodes/static/qr_1", :object],
    [:Pix, :pay_qr_code, [{ qrCode: { payload: "000201" }, value: 10 }], :post, "/pix/qrCodes/pay", :object],
    [:Pix, :cancel_transaction, ["trx_1"], :post, "/pix/transactions/trx_1/cancel", :object],
    [:Pix, :recurrings, [], :get, "/pix/transactions/recurrings", :list],
    [:Pix, :retrieve_recurring, ["rec_1"], :get, "/pix/transactions/recurrings/rec_1", :object],
    [:Pix, :cancel_recurring, ["rec_1"], :post, "/pix/transactions/recurrings/rec_1/cancel", :object],
    [:Pix, :recurring_items, ["rec_1"], :get, "/pix/transactions/recurrings/rec_1/items", :list],
    [:Pix, :cancel_recurring_item, ["itm_1"], :post, "/pix/transactions/recurrings/items/itm_1/cancel", :object],

    # Pix Automático
    [:PixAutomatic, :retrieve, ["aut_1"], :get, "/pix/automatic/authorizations/aut_1", :object],
    [:PixAutomatic, :payment_instructions, [], :get, "/pix/automatic/paymentInstructions", :list],
    [:PixAutomatic, :retrieve_payment_instruction, ["ins_1"], :get, "/pix/automatic/paymentInstructions/ins_1",
     :object],
    [:PixAutomatic, :retry_payment_instruction, ["ins_1", { dueDate: "2026-12-01" }], :post,
     "/pix/automatic/paymentInstructions/ins_1/retries", :object],

    # Bill payments and mobile recharges
    [:BillPayment, :simulate, [{ identificationField: "123" }], :post, "/bill/simulate", :object],
    [:BillPayment, :cancel, ["bil_1"], :post, "/bill/bil_1/cancel", :object],
    [:MobilePhoneRecharge, :create, [{ value: 20, phoneNumber: "11999999999" }], :post, "/mobilePhoneRecharges",
     :object],
    [:MobilePhoneRecharge, :list, [], :get, "/mobilePhoneRecharges", :list],
    [:MobilePhoneRecharge, :retrieve, ["rch_1"], :get, "/mobilePhoneRecharges/rch_1", :object],
    [:MobilePhoneRecharge, :cancel, ["rch_1"], :post, "/mobilePhoneRecharges/rch_1/cancel", :object],
    [:MobilePhoneRecharge, :provider, ["11999999999"], :get, "/mobilePhoneRecharges/11999999999/provider", :object],

    # Account, finance and webhooks
    [:Finance, :split_statistics, [], :get, "/finance/split/statistics", :object],
    [:MyAccount, :account_number, [], :get, "/myAccount/accountNumber", :object],
    [:MyAccount, :fees, [], :get, "/myAccount/fees/", :object],
    [:MyAccount, :wallets, [], :get, "/wallets/", :list],
    [:MyAccount, :payment_checkout_config, [], :get, "/myAccount/paymentCheckoutConfig/", :object],
    [:MyAccount, :update_payment_checkout_config, [{ enabled: true }], :post, "/myAccount/paymentCheckoutConfig/",
     :object],
    [:MyAccount, :delete_white_label, [{ removeReason: "Liberar dados" }], :delete,
     "/myAccount/?removeReason=Liberar+dados", :object],
    [:Webhook, :remove_backoff, ["wh_1"], :post, "/webhooks/wh_1/removeBackoff", :object],

    # Subaccounts and KYC documents
    [:Subaccount, :create_access_token, ["acc_1", { name: "ci" }], :post, "/accounts/acc_1/accessTokens", :object],
    [:Subaccount, :access_tokens, ["acc_1"], :get, "/accounts/acc_1/accessTokens", :list],
    [:Subaccount, :update_access_token, %w[acc_1 tok_1], :put, "/accounts/acc_1/accessTokens/tok_1", :object],
    [:Subaccount, :delete_access_token, %w[acc_1 tok_1], :delete, "/accounts/acc_1/accessTokens/tok_1", :object],
    [:Subaccount, :resend_activation_link, ["acc_1"], :post, "/accounts/acc_1/resendActivationLink", :object],
    [:Document, :retrieve_file, ["fil_1"], :get, "/myAccount/documents/files/fil_1", :object]
  ]

  endpoints.each do |row|
    resource, method, args, verb, path, returns = row

    it "#{resource}.#{method} #{verb.upcase}s #{path}" do
      body = returns == :list ? list_response([{ "id" => "x_1" }]) : { "id" => "x_1" }
      request = stub_asaas(verb, path, body: body)

      result = Asaas::Resources.const_get(resource).public_send(method, *args)

      expect(request).to have_been_requested.once
      case returns
      when :list then expect(result).to be_a(Asaas::ListObject)
      when :raw then expect(result).to be_a(String)
      else expect(result).to be_a(Asaas::AsaasObject)
      end
    end
  end

  describe "per-call options" do
    it "forwards the api_key and a stable idempotency key" do
      request = stub_request(:post, "#{ASAAS_BASE_URL}/pix/qrCodes/pay")
                .with(headers: { "access_token" => "sub_key", "Idempotency-Key" => "pay-qr-1" })
                .to_return(status: 200, body: { "id" => "trx_1" }.to_json)

      Asaas::Resources::Pix.pay_qr_code({ value: 10 }, api_key: "sub_key", idempotency_key: "pay-qr-1")

      expect(request).to have_been_requested.once
    end

    it "does not retry when retryable is false" do
      Asaas.configure do |config|
        config.max_retries = 2
        config.retry_delay = 0
      end
      request = stub_request(:get, "#{ASAAS_BASE_URL}/pix/automatic/paymentInstructions")
                .to_return(status: 503, body: { errors: [] }.to_json)

      expect { Asaas::Resources::PixAutomatic.payment_instructions({}, retryable: false) }
        .to raise_error(Asaas::ServerError)
      expect(request).to have_been_requested.once
    end

    it "keeps the options on the next page of a list" do
      first = stub_request(:get, "#{ASAAS_BASE_URL}/pix/transactions/recurrings")
              .with(headers: { "access_token" => "sub_key" })
              .to_return(status: 200, body: list_response([{ "id" => "rec_1" }], has_more: true).to_json)
      second = stub_request(:get, "#{ASAAS_BASE_URL}/pix/transactions/recurrings?limit=10&offset=10")
               .with(headers: { "access_token" => "sub_key" })
               .to_return(status: 200, body: list_response([{ "id" => "rec_2" }]).to_json)

      ids = Asaas::Resources::Pix.recurrings({}, api_key: "sub_key").auto_paging_each.map(&:id)

      expect(ids).to eq(%w[rec_1 rec_2])
      expect([first, second]).to all(have_been_requested.once)
    end
  end

  describe "PDF endpoints" do
    it "return the binary body and ask for a PDF" do
      pdf = "%PDF-1.4 \xFF\xFE".b
      request = stub_request(:get, "#{ASAAS_BASE_URL}/installments/ins_1/paymentBook")
                .with(headers: { "Accept" => "application/pdf" })
                .to_return(status: 200, body: pdf, headers: { "Content-Type" => "application/pdf" })

      result = Asaas::Resources::Installment.payment_book("ins_1")

      expect(result).to eq(pdf)
      expect(result.encoding).to eq(Encoding::BINARY)
      expect(request).to have_been_requested.once
    end

    it "still raise the API error when the call fails" do
      stub_asaas(:get, "/installments/ins_1/paymentBook", status: 404,
                                                          body: { errors: [{ description: "Not found" }] })

      expect { Asaas::Resources::Installment.payment_book("ins_1") }.to raise_error(Asaas::NotFoundError)
    end
  end
end
