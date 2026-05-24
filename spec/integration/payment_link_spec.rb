# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::PaymentLink, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  let(:link_params) do
    {
      name: "VCR Test Link", billingType: "UNDEFINED", chargeType: "DETACHED",
      value: 75.0, endDate: "2026-12-31", dueDateLimitDays: 5
    }
  end

  it "creates a payment link" do
    result = described_class.create(**link_params)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).not_to be_nil
    expect(result.name).to eq("VCR Test Link")
    expect(result.chargeType).to eq("DETACHED")
  end

  it "retrieves a payment link" do
    created = described_class.create(**link_params.merge(name: "VCR Retrieve Link"))
    result  = described_class.retrieve(created.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(created.id)
    expect(result.name).to eq("VCR Retrieve Link")
  end

  it "lists payment links" do
    result = described_class.list(limit: 5)

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.total_count).to be_an(Integer)
  end

  it "updates a payment link" do
    created = described_class.create(**link_params.merge(name: "VCR Update Link"))
    result  = described_class.update(created.id, name: "VCR Updated Link")

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(created.id)
    expect(result.name).to eq("VCR Updated Link")
  end

  it "deletes a payment link" do
    created = described_class.create(**link_params.merge(name: "VCR Delete Link", value: 10.0))
    result  = described_class.delete(created.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.deleted).to eq(true)
  end
end
