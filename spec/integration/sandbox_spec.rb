# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Sandbox, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  it "approves account" do
    result = described_class.approve_account

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.general).to eq("APPROVED")
  end

  it "confirms a payment" do
    customer = Asaas::Resources::Customer.create(
      name: "Sandbox Confirm Customer", email: "sandbox-confirm@test.com", cpfCnpj: "98765432100"
    )
    payment = Asaas::Resources::Payment.create(
      customer: customer.id, billingType: "BOLETO", value: 10.0, dueDate: "2026-12-31"
    )

    result = described_class.confirm_payment(payment.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(payment.id)
    expect(result.status).to eq("RECEIVED")
  end

  it "forces a payment overdue" do
    customer = Asaas::Resources::Customer.create(
      name: "Sandbox Overdue Customer", email: "sandbox-overdue@test.com", cpfCnpj: "30621143049"
    )
    payment = Asaas::Resources::Payment.create(
      customer: customer.id, billingType: "BOLETO", value: 10.0, dueDate: "2026-12-31"
    )

    result = described_class.overdue_payment(payment.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(payment.id)
    expect(result.status).to eq("OVERDUE")
  end
end
