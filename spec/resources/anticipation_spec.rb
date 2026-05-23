# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Anticipation do
  let(:id) { "ant_123" }
  let(:anticipation_attrs) { { "id" => id, "value" => 800.0, "status" => "PENDING" } }

  describe ".create" do
    it "POSTs to /anticipations and returns an AsaasObject" do
      stub_asaas(:post, "/anticipations", body: anticipation_attrs)

      result = described_class.create(payment: "pay_1")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("PENDING")
    end
  end

  describe ".retrieve" do
    it "GETs /anticipations/:id and returns an AsaasObject" do
      stub_asaas(:get, "/anticipations/#{id}", body: anticipation_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.value).to eq(800.0)
    end
  end

  describe ".list" do
    it "GETs /anticipations and returns a ListObject" do
      stub_asaas(:get, "/anticipations", body: list_response([anticipation_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.status).to eq("PENDING")
    end
  end

  describe ".delete" do
    it "DELETEs /anticipations/:id (cancel)" do
      stub_asaas(:delete, "/anticipations/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result.deleted?).to be true
    end
  end

  describe ".simulate" do
    it "POSTs to /anticipations/simulate and returns an AsaasObject" do
      simulation = { "netValue" => 780.0, "fee" => 20.0 }
      stub_asaas(:post, "/anticipations/simulate", body: simulation)

      result = described_class.simulate(payment: "pay_1")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.netValue).to eq(780.0)
    end
  end
end
