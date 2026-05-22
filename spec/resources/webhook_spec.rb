# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Webhook do
  let(:id) { "web_123" }
  let(:webhook_attrs) { { "id" => id, "url" => "https://example.com/webhook", "enabled" => true } }

  describe ".create" do
    it "POSTs to /webhooks and returns an AsaasObject" do
      stub_asaas(:post, "/webhooks", body: webhook_attrs)

      result = described_class.create(url: "https://example.com/webhook", email: "dev@example.com")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.url).to eq("https://example.com/webhook")
      expect(result.enabled?).to be true
    end
  end

  describe ".retrieve" do
    it "GETs /webhooks/:id and returns an AsaasObject" do
      stub_asaas(:get, "/webhooks/#{id}", body: webhook_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.id).to eq(id)
    end
  end

  describe ".update" do
    it "PUTs to /webhooks/:id and returns an AsaasObject" do
      updated = webhook_attrs.merge("url" => "https://example.com/new-webhook")
      stub_asaas(:put, "/webhooks/#{id}", body: updated)

      result = described_class.update(id, url: "https://example.com/new-webhook")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.url).to eq("https://example.com/new-webhook")
    end
  end

  describe ".delete" do
    it "DELETEs /webhooks/:id" do
      stub_asaas(:delete, "/webhooks/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.deleted?).to be true
    end
  end

  describe ".list" do
    it "GETs /webhooks and returns a ListObject" do
      stub_asaas(:get, "/webhooks", body: list_response([webhook_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.url).to eq("https://example.com/webhook")
    end
  end

  describe ".remove_penalty" do
    it "POSTs to /webhooks/:id/removePenalty and returns an AsaasObject" do
      stub_asaas(:post, "/webhooks/#{id}/removePenalty", body: webhook_attrs)

      result = described_class.remove_penalty(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.id).to eq(id)
    end
  end
end
