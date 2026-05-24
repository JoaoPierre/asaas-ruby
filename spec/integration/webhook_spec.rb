# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Webhook, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  let(:webhook_params) do
    {
      url: "https://vcr-test.example.com/webhook",
      email: "vcr@example.com",
      name: "VCR Test Webhook",
      sendType: "SEQUENTIALLY",
      enabled: true,
      interrupted: false,
      apiVersion: 3,
      authToken: "vcr-test-webhook-authtoken-secure-1234",
      events: %w[PAYMENT_RECEIVED PAYMENT_OVERDUE]
    }
  end

  it "creates a webhook" do
    result = described_class.create(**webhook_params)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).not_to be_nil
    expect(result.url).to eq("https://vcr-test.example.com/webhook")
  end

  it "retrieves a webhook" do
    created = described_class.create(**webhook_params.merge(url: "https://vcr-retrieve.example.com/webhook"))
    result  = described_class.retrieve(created.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(created.id)
    expect(result.url).to eq("https://vcr-retrieve.example.com/webhook")
  end

  it "updates a webhook" do
    created = described_class.create(**webhook_params.merge(url: "https://vcr-update.example.com/webhook"))
    result  = described_class.update(created.id, url: "https://vcr-updated.example.com/webhook")

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(created.id)
    expect(result.url).to eq("https://vcr-updated.example.com/webhook")
  end

  it "lists webhooks" do
    result = described_class.list

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.total_count).to be_an(Integer)
  end

  it "deletes a webhook" do
    created = described_class.create(**webhook_params.merge(url: "https://vcr-delete.example.com/webhook"))
    result  = described_class.delete(created.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.deleted).to eq(true)
  end
end
