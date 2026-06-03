# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Document do
  let(:group_id) { "172ed152-4fa4-43ad-9b69-39c323e9526c" }
  let(:file_id)  { "8d257732-2220-11ec-b695-b6af4a64184d" }

  describe ".pending" do
    it "GETs /myAccount/documents and returns an AsaasObject with document groups" do
      body = {
        "rejectReasons" => nil,
        "data" => [
          { "id" => group_id, "status" => "NOT_SENT", "type" => "IDENTIFICATION",
            "onboardingUrl" => "https://example.com/onboarding/abc" }
        ]
      }
      stub_asaas(:get, "/myAccount/documents", body: body)

      result = described_class.pending

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.data.first.id).to eq(group_id)
      expect(result.data.first.onboardingUrl).to eq("https://example.com/onboarding/abc")
    end

    it "uses a per-call api_key" do
      stub = stub_request(:get, "#{ASAAS_BASE_URL}/myAccount/documents")
             .with(headers: { "access_token" => "aact_sub_key" })
             .to_return(status: 200, body: { "data" => [] }.to_json)

      described_class.pending(api_key: "aact_sub_key")

      expect(stub).to have_been_requested
    end
  end

  describe ".send_document" do
    it "POSTs a multipart upload to /myAccount/documents/:group_id" do
      stub = stub_request(:post, "#{ASAAS_BASE_URL}/myAccount/documents/#{group_id}")
             .with(headers: { "Content-Type" => %r{multipart/form-data} })
             .to_return(status: 200, body: { "id" => file_id, "status" => "PENDING" }.to_json)

      result = described_class.send_document(
        group_id,
        file: StringIO.new("file-bytes"),
        type: "IDENTIFICATION"
      )

      expect(stub).to have_been_requested
      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("PENDING")
    end

    it "forwards a per-call api_key" do
      stub = stub_request(:post, "#{ASAAS_BASE_URL}/myAccount/documents/#{group_id}")
             .with(headers: { "access_token" => "aact_sub_key" })
             .to_return(status: 200, body: { "id" => file_id }.to_json)

      described_class.send_document(
        group_id,
        file: StringIO.new("file-bytes"),
        type: "IDENTIFICATION",
        api_key: "aact_sub_key"
      )

      expect(stub).to have_been_requested
    end
  end

  describe ".delete_file" do
    it "DELETEs /myAccount/documents/files/:file_id" do
      stub_asaas(:delete, "/myAccount/documents/files/#{file_id}", body: { "deleted" => true, "id" => file_id })

      result = described_class.delete_file(file_id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.deleted).to be(true)
    end
  end
end
