# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Pix do
  describe ".create_key" do
    it "POSTs to /pix/addressKeys and returns an AsaasObject" do
      stub_asaas(:post, "/pix/addressKeys", body: { "id" => "key_1", "key" => "joao@email.com", "type" => "EMAIL" })

      result = described_class.create_key(type: "EMAIL", key: "joao@email.com")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.type).to eq("EMAIL")
    end
  end

  describe ".list_keys" do
    it "GETs /pix/addressKeys and returns a ListObject" do
      key = { "id" => "key_1", "key" => "joao@email.com", "type" => "EMAIL" }
      stub_asaas(:get, "/pix/addressKeys", body: list_response([key]))

      result = described_class.list_keys

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.key).to eq("joao@email.com")
    end
  end

  describe ".delete_key" do
    it "DELETEs /pix/addressKeys/:id and returns an AsaasObject" do
      stub_asaas(:delete, "/pix/addressKeys/key_1", body: { "deleted" => true })

      result = described_class.delete_key("key_1")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.deleted?).to be true
    end
  end

  describe ".create_qr_code" do
    it "POSTs to /pix/qrCodes/static and returns an AsaasObject" do
      stub_asaas(:post, "/pix/qrCodes/static", body: { "id" => "qr_1", "payload" => "00020101..." })

      result = described_class.create_qr_code(addressKey: "joao@email.com", value: 50.0)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.id).to eq("qr_1")
    end
  end

  describe ".transactions" do
    it "GETs /pix/transactions and returns a ListObject" do
      tx = { "id" => "tx_1", "value" => 200.0, "type" => "CREDIT" }
      stub_asaas(:get, "/pix/transactions", body: list_response([tx]))

      result = described_class.transactions

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.type).to eq("CREDIT")
    end
  end

  describe ".decode_qr_code" do
    it "POSTs to /pix/qrCodes/decode and returns an AsaasObject" do
      decoded = { "addressKey" => "joao@email.com", "value" => 50.0 }
      stub_asaas(:post, "/pix/qrCodes/decode", body: decoded)

      result = described_class.decode_qr_code(payload: "00020101...")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.addressKey).to eq("joao@email.com")
    end
  end

  describe ".retrieve_transaction" do
    let(:id) { "06391ba9-cbf9-4926-8988-374ac5d71cae" }

    it "reads one transaction with the original subaccount credential and no request body" do
      request = stub_request(:get, "#{ASAAS_BASE_URL}/pix/transactions/#{id}")
                .with(headers: { "access_token" => "synthetic-subaccount" }, body: "")
                .to_return(status: 200, body: { id: id, type: "CREDIT_REFUND", value: 10 }.to_json)

      result = described_class.retrieve_transaction(id, api_key: "synthetic-subaccount", retryable: false)

      expect(result.id).to eq(id)
      expect(result.value).to eq(10)
      expect(request).to have_been_requested.once
    end

    it "rejects path traversal before sending a request" do
      expect { described_class.retrieve_transaction("../payments/pay_other") }.to raise_error(ArgumentError)
      expect(WebMock).not_to have_requested(:get, %r{pix/transactions})
    end

    it "does not retry a failed read when retryable is false" do
      Asaas.config.max_retries = 2
      request = stub_request(:get, "#{ASAAS_BASE_URL}/pix/transactions/#{id}")
                .to_return(status: 500, body: { errors: [] }.to_json)

      expect { described_class.retrieve_transaction(id, retryable: false) }.to raise_error(Asaas::ServerError)
      expect(request).to have_been_requested.once
    end
  end
end
