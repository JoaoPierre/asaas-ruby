# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Dunning do
  let(:id) { "dun_123" }
  let(:dunning_attrs) { { "id" => id, "status" => "REQUESTED", "type" => "CREDIT_BUREAU" } }

  describe ".create" do
    it "POSTs to /dunnings and returns an AsaasObject" do
      stub_asaas(:post, "/dunnings", body: dunning_attrs)

      result = described_class.create(payment: "pay_1", type: "CREDIT_BUREAU")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("REQUESTED")
    end
  end

  describe ".retrieve" do
    it "GETs /dunnings/:id and returns an AsaasObject" do
      stub_asaas(:get, "/dunnings/#{id}", body: dunning_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.type).to eq("CREDIT_BUREAU")
    end
  end

  describe ".list" do
    it "GETs /dunnings and returns a ListObject" do
      stub_asaas(:get, "/dunnings", body: list_response([dunning_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.status).to eq("REQUESTED")
    end
  end

  describe ".delete" do
    it "DELETEs /dunnings/:id (cancel)" do
      stub_asaas(:delete, "/dunnings/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result.deleted?).to be true
    end
  end

  describe ".resend_documents" do
    it "POSTs to /dunnings/:id/documents" do
      stub_asaas(:post, "/dunnings/#{id}/documents", body: dunning_attrs)

      result = described_class.resend_documents(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.id).to eq(id)
    end
  end
end
