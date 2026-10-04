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

  describe ".commercial_info" do
    it "GETs the authenticated account's commercial info and returns an AsaasObject" do
      response_body = { "incomeValue" => 24_000.0, "site" => "https://scoby.example" }
      request = stub_request(:get, "#{ASAAS_BASE_URL}/myAccount/commercialInfo/")
                .with(body: "", headers: { "access_token" => "aact_sub_key" })
                .to_return(status: 200, body: response_body.to_json)

      result = described_class.commercial_info(api_key: "aact_sub_key")

      expect(request).to have_been_requested.once
      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.incomeValue).to eq(24_000.0)
      expect(result.site).to eq("https://scoby.example")
    end
  end

  describe ".update_commercial_info" do
    it "POSTs the full commercial profile and returns an AsaasObject" do
      profile = {
        incomeValue: 24_000.0,
        companyName: "Scoby",
        site: "https://scoby.example"
      }
      response_body = { "incomeValue" => 24_000.0, "status" => "PENDING" }
      request = stub_request(:post, "#{ASAAS_BASE_URL}/myAccount/commercialInfo/")
                .with(body: profile.to_json, headers: { "access_token" => "aact_sub_key" })
                .to_return(status: 200, body: response_body.to_json)

      result = described_class.update_commercial_info(profile, api_key: "aact_sub_key")

      expect(request).to have_been_requested.once
      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.incomeValue).to eq(24_000.0)
      expect(result.status).to eq("PENDING")
    end
  end
end
