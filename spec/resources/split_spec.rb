# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Split do
  let(:split_attrs) { { "id" => "spl_1", "value" => 30.0, "status" => "DONE" } }

  describe ".paid" do
    it "GETs /splits/paid and returns a ListObject" do
      stub_asaas(:get, "/splits/paid", body: list_response([split_attrs]))

      result = described_class.paid

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.status).to eq("DONE")
    end
  end

  describe ".received" do
    it "GETs /splits/received and returns a ListObject" do
      stub_asaas(:get, "/splits/received", body: list_response([split_attrs]))

      result = described_class.received

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.value).to eq(30.0)
    end
  end

  describe ".retrieve_paid" do
    it "GETs /splits/paid/:id and returns an AsaasObject" do
      stub_asaas(:get, "/splits/paid/spl_1", body: split_attrs)

      result = described_class.retrieve_paid("spl_1")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("DONE")
    end
  end

  describe ".retrieve_received" do
    it "GETs /splits/received/:id and returns an AsaasObject" do
      stub_asaas(:get, "/splits/received/spl_1", body: split_attrs)

      result = described_class.retrieve_received("spl_1")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.value).to eq(30.0)
    end
  end
end
