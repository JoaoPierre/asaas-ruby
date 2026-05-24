# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Subaccount do
  let(:id) { "sub_123" }
  let(:subaccount_attrs) { { "id" => id, "name" => "Loja Parceira", "email" => "loja@example.com" } }

  describe ".create" do
    it "POSTs to /accounts and returns an AsaasObject" do
      stub_asaas(:post, "/accounts", body: subaccount_attrs)

      result = described_class.create(name: "Loja Parceira", email: "loja@example.com", cpfCnpj: "000.000.000-00")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.name).to eq("Loja Parceira")
    end
  end

  describe ".retrieve" do
    it "GETs /accounts/:id and returns an AsaasObject" do
      stub_asaas(:get, "/accounts/#{id}", body: subaccount_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.email).to eq("loja@example.com")
    end
  end

  describe ".list" do
    it "GETs /accounts and returns a ListObject" do
      stub_asaas(:get, "/accounts", body: list_response([subaccount_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.name).to eq("Loja Parceira")
    end
  end

  describe ".create_api_key" do
    it "POSTs to /accounts/:id/apiKeys and returns an AsaasObject" do
      stub_asaas(:post, "/accounts/#{id}/apiKeys", body: { "id" => "key_1", "token" => "aact_xyz" })

      result = described_class.create_api_key(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.token).to eq("aact_xyz")
    end
  end

  describe ".api_keys" do
    it "GETs /accounts/:id/apiKeys and returns a ListObject" do
      key = { "id" => "key_1", "token" => "aact_xyz" }
      stub_asaas(:get, "/accounts/#{id}/apiKeys", body: list_response([key]))

      result = described_class.api_keys(id)

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.token).to eq("aact_xyz")
    end
  end
end
