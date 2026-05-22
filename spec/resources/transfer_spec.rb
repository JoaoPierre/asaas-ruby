# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Transfer do
  let(:id) { "tra_123" }
  let(:transfer_attrs) { { "id" => id, "value" => 500.0, "status" => "PENDING", "type" => "ASAAS" } }

  describe ".create" do
    it "POSTs to /transfers and returns an AsaasObject" do
      stub_asaas(:post, "/transfers", body: transfer_attrs)

      result = described_class.create(value: 500.0, walletId: "wal_abc")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.value).to eq(500.0)
      expect(result.status).to eq("PENDING")
    end
  end

  describe ".retrieve" do
    it "GETs /transfers/:id and returns an AsaasObject" do
      stub_asaas(:get, "/transfers/#{id}", body: transfer_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.type).to eq("ASAAS")
    end
  end

  describe ".list" do
    it "GETs /transfers and returns a ListObject" do
      stub_asaas(:get, "/transfers", body: list_response([transfer_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.status).to eq("PENDING")
    end
  end

  describe ".delete" do
    it "DELETEs /transfers/:id (cancel)" do
      stub_asaas(:delete, "/transfers/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result.deleted?).to be true
    end
  end
end
