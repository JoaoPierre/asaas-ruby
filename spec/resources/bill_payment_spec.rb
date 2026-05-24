# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::BillPayment do
  let(:id) { "bil_123" }
  let(:bill_attrs) { { "id" => id, "status" => "PENDING", "value" => 150.0, "description" => "Conta de luz" } }

  describe ".create" do
    it "POSTs to /bill and returns an AsaasObject" do
      stub_asaas(:post, "/bill", body: bill_attrs)

      result = described_class.create(identificationField: "123456789", value: 150.0)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("PENDING")
    end
  end

  describe ".retrieve" do
    it "GETs /bill/:id and returns an AsaasObject" do
      stub_asaas(:get, "/bill/#{id}", body: bill_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.description).to eq("Conta de luz")
    end
  end

  describe ".list" do
    it "GETs /bill and returns a ListObject" do
      stub_asaas(:get, "/bill", body: list_response([bill_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.value).to eq(150.0)
    end
  end

  describe ".delete" do
    it "DELETEs /bill/:id (cancel)" do
      stub_asaas(:delete, "/bill/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result.deleted?).to be true
    end
  end
end
