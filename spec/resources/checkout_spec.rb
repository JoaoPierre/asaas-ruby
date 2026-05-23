# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Checkout do
  let(:id) { "chk_123" }
  let(:checkout_attrs) { { "id" => id, "billingType" => "UNDEFINED", "totalValue" => 150.0 } }

  describe ".create" do
    it "POSTs to /checkouts and returns an AsaasObject" do
      stub_asaas(:post, "/checkouts", body: checkout_attrs)

      result = described_class.create(billingType: "UNDEFINED", totalValue: 150.0)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.totalValue).to eq(150.0)
    end
  end

  describe ".retrieve" do
    it "GETs /checkouts/:id and returns an AsaasObject" do
      stub_asaas(:get, "/checkouts/#{id}", body: checkout_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.id).to eq(id)
    end
  end

  describe ".delete" do
    it "DELETEs /checkouts/:id (cancel)" do
      stub_asaas(:delete, "/checkouts/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result.deleted?).to be true
    end
  end
end
