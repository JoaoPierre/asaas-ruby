# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Payment, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  it "creates a payment" do
    customer = Asaas::Resources::Customer.create(
      name: "VCR Payment Customer", email: "vcr-pay-create@test.com", cpfCnpj: "98765432100"
    )
    result = described_class.create(
      customer: customer.id, billingType: "BOLETO", value: 100.0, dueDate: "2026-12-31"
    )

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.object).to eq("payment")
    expect(result.id).to start_with("pay_")
    expect(result.customer).to eq(customer.id)
    expect(result.billingType).to eq("BOLETO")
    expect(result.value).to eq(100.0)
    expect(result.netValue).to be < 100.0
    expect(result.status).to eq("PENDING")
    expect(result.dueDate).to eq("2026-12-31")
    expect(result.deleted).to eq(false)
    expect(result.bankSlipUrl).not_to be_nil
    expect(result.invoiceUrl).not_to be_nil
    expect(result.discount).to be_a(Asaas::AsaasObject)
    expect(result.fine).to be_a(Asaas::AsaasObject)
    expect(result.interest).to be_a(Asaas::AsaasObject)
  end

  it "retrieves a payment" do
    customer = Asaas::Resources::Customer.create(
      name: "VCR Payment Customer Retrieve", email: "vcr-pay-retrieve@test.com", cpfCnpj: "30621143049"
    )
    created = described_class.create(
      customer: customer.id, billingType: "BOLETO", value: 50.0, dueDate: "2026-12-31"
    )
    result = described_class.retrieve(created.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.object).to eq("payment")
    expect(result.id).to eq(created.id)
    expect(result.customer).to eq(customer.id)
    expect(result.value).to eq(50.0)
    expect(result.billingType).to eq("BOLETO")
    expect(result.status).to eq("PENDING")
  end

  it "lists payments and returns a ListObject" do
    result = described_class.list(limit: 5)

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.limit).to eq(5)
    expect(result.offset).to eq(0)
    expect(result.total_count).to be_an(Integer)
  end

  it "lists payments filtered by status" do
    result = described_class.list(status: %w[PENDING OVERDUE])

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    result.data.each do |payment|
      expect(payment.status).to be_in(%w[PENDING OVERDUE])
    end
  end
end
