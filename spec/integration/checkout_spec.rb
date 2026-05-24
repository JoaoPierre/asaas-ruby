# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Checkout, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  let(:checkout_params) do
    {
      billingTypes: %w[CREDIT_CARD PIX],
      chargeTypes: %w[DETACHED],
      name: "VCR Checkout",
      endDate: "2026-12-31",
      callback: { successUrl: "https://example.com/success", cancelUrl: "https://example.com/cancel",
                  autoRedirect: false },
      items: [{ name: "VCR Item", description: "Test item", quantity: 1, value: 150.0 }]
    }
  end

  it "creates a checkout" do
    result = described_class.create(**checkout_params)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).not_to be_nil
    expect(result.status).to eq("ACTIVE")
    expect(result.link).to be_a(String)
  end
end
