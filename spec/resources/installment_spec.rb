# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Installment do
  let(:id) { "ins_123" }
  let(:installment_attrs) { { "id" => id, "value" => 1200.0, "installmentCount" => 12, "status" => "ACTIVE" } }

  describe ".create" do
    it "POSTs to /installments and returns an AsaasObject" do
      stub_asaas(:post, "/installments", body: installment_attrs)

      result = described_class.create(customer: "cus_1", value: 1200.0, installmentCount: 12,
                                      billingType: "CREDIT_CARD")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.installmentCount).to eq(12)
    end
  end

  describe ".retrieve" do
    it "GETs /installments/:id and returns an AsaasObject" do
      stub_asaas(:get, "/installments/#{id}", body: installment_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.value).to eq(1200.0)
    end
  end

  describe ".list" do
    it "GETs /installments and returns a ListObject" do
      stub_asaas(:get, "/installments", body: list_response([installment_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.status).to eq("ACTIVE")
    end
  end

  describe ".delete" do
    it "DELETEs /installments/:id" do
      stub_asaas(:delete, "/installments/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result.deleted?).to be true
    end
  end

  describe ".update_splits" do
    it "PUTs to /installments/:id/splits and returns an AsaasObject" do
      splits = { "splits" => [{ "walletId" => "wal_1", "percentualValue" => 10.0 }] }
      stub_asaas(:put, "/installments/#{id}/splits", body: splits)

      result = described_class.update_splits(id, splits: [{ walletId: "wal_1", percentualValue: 10.0 }])

      expect(result).to be_a(Asaas::AsaasObject)
    end
  end
end
