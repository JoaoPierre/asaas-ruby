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
    it "DELETEs /transfers/:id" do
      stub_asaas(:delete, "/transfers/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result.deleted?).to be true
    end
  end

  describe ".cancel" do
    it "DELETEs /transfers/:id/cancel and returns the cancelled transfer" do
      stub_asaas(:delete, "/transfers/#{id}/cancel", body: transfer_attrs.merge("status" => "CANCELLED"))

      result = described_class.cancel(id)

      expect(result.status).to eq("CANCELLED")
    end

    it "does not retry when retryable is false" do
      request = stub_request(:delete, "#{ASAAS_BASE_URL}/transfers/#{id}/cancel")
                .to_return(status: 503, body: { "errors" => [] }.to_json)

      expect { described_class.cancel(id, retryable: false) }.to raise_error(Asaas::ServerError)
      expect(request).to have_been_requested.once
    end
  end
end
