# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Chargeback do
  let(:id) { "cbk_123" }
  let(:chargeback_attrs) { { "id" => id, "status" => "REQUESTED", "value" => 200.0 } }

  describe ".retrieve" do
    it "GETs /chargebacks/:id and returns an AsaasObject" do
      stub_asaas(:get, "/chargebacks/#{id}", body: chargeback_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.value).to eq(200.0)
    end
  end

  describe ".list" do
    it "GETs /chargebacks and returns a ListObject" do
      stub_asaas(:get, "/chargebacks", body: list_response([chargeback_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.status).to eq("REQUESTED")
    end
  end

  describe ".dispute" do
    it "POSTs to /chargebacks/:id/disputes and returns an AsaasObject" do
      stub_asaas(:post, "/chargebacks/#{id}/disputes", body: chargeback_attrs.merge("status" => "DISPUTE_REQUESTED"))

      result = described_class.dispute(id, description: "Item entregue conforme pedido")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("DISPUTE_REQUESTED")
    end
  end
end
