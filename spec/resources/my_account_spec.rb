# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::MyAccount do
  describe ".status" do
    it "GETs /myAccount/status and returns an AsaasObject" do
      body = {
        "id" => "a910f50b-8745-4bc6-89fe-f1931c6a2e05",
        "commercialInfo" => "APPROVED",
        "bankAccountInfo" => "PENDING",
        "documentation" => "AWAITING_APPROVAL",
        "general" => "PENDING"
      }
      stub_asaas(:get, "/myAccount/status", body: body)

      result = described_class.status

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.commercialInfo).to eq("APPROVED")
      expect(result.general).to eq("PENDING")
    end

    it "uses a per-call api_key" do
      stub = stub_request(:get, "#{ASAAS_BASE_URL}/myAccount/status")
             .with(headers: { "access_token" => "aact_sub_key" })
             .to_return(status: 200, body: { "general" => "APPROVED" }.to_json)

      described_class.status(api_key: "aact_sub_key")

      expect(stub).to have_been_requested
    end
  end
end
