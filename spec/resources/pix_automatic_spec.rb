# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::PixAutomatic do
  let(:id) { "aut_123" }
  let(:authorization_attrs) { { "id" => id, "status" => "ACTIVE", "value" => 99.90 } }

  describe ".create" do
    it "POSTs to /pix/authorizations and returns an AsaasObject" do
      stub_asaas(:post, "/pix/authorizations", body: authorization_attrs)

      result = described_class.create(customer: "cus_1", value: 99.90)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("ACTIVE")
    end
  end

  describe ".list" do
    it "GETs /pix/authorizations and returns a ListObject" do
      stub_asaas(:get, "/pix/authorizations", body: list_response([authorization_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.value).to eq(99.90)
    end
  end

  describe ".delete" do
    it "DELETEs /pix/authorizations/:id (cancel)" do
      stub_asaas(:delete, "/pix/authorizations/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result.deleted?).to be true
    end
  end
end
