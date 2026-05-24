# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Subscription, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  it "creates a subscription" do
    customer = Asaas::Resources::Customer.create(
      name: "VCR Subscription Customer", email: "vcr-sub-create@test.com", cpfCnpj: "05181930557"
    )
    result = described_class.create(
      customer: customer.id, billingType: "BOLETO", value: 49.90,
      nextDueDate: "2026-12-31", cycle: "MONTHLY"
    )

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).not_to be_nil
    expect(result.cycle).to eq("MONTHLY")
    expect(result.billingType).to eq("BOLETO")
    expect(result.value).to eq(49.90)
    expect(result.status).to eq("ACTIVE")
  end

  it "retrieves a subscription" do
    customer = Asaas::Resources::Customer.create(
      name: "VCR Subscription Retrieve", email: "vcr-sub-retrieve@test.com", cpfCnpj: "81109406177"
    )
    created = described_class.create(
      customer: customer.id, billingType: "BOLETO", value: 29.90,
      nextDueDate: "2026-12-31", cycle: "MONTHLY"
    )
    result = described_class.retrieve(created.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(created.id)
    expect(result.value).to eq(29.90)
    expect(result.cycle).to eq("MONTHLY")
  end

  it "lists subscriptions" do
    result = described_class.list(limit: 5)

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.limit).to eq(5)
    expect(result.total_count).to be_an(Integer)
  end

  it "updates a subscription" do
    customer = Asaas::Resources::Customer.create(
      name: "VCR Subscription Update", email: "vcr-sub-update@test.com", cpfCnpj: "35932640804"
    )
    created = described_class.create(
      customer: customer.id, billingType: "BOLETO", value: 19.90,
      nextDueDate: "2026-12-31", cycle: "MONTHLY"
    )
    result = described_class.update(created.id, value: 39.90)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(created.id)
    expect(result.value).to eq(39.90)
  end

  it "deletes a subscription" do
    customer = Asaas::Resources::Customer.create(
      name: "VCR Subscription Delete", email: "vcr-sub-delete@test.com", cpfCnpj: "09750971728"
    )
    created = described_class.create(
      customer: customer.id, billingType: "BOLETO", value: 9.90,
      nextDueDate: "2026-12-31", cycle: "MONTHLY"
    )
    result = described_class.delete(created.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.deleted).to eq(true)
  end
end
