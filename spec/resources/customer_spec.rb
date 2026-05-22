# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Customer do
  let(:id) { "cus_123" }
  let(:customer_attrs) { { "id" => id, "name" => "João Silva", "cpfCnpj" => "000.000.000-00" } }

  describe ".create" do
    it "POSTs to /customers and returns an AsaasObject" do
      stub_asaas(:post, "/customers", body: customer_attrs)

      result = described_class.create(name: "João Silva", cpfCnpj: "000.000.000-00")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.id).to eq(id)
      expect(result.name).to eq("João Silva")
    end
  end

  describe ".retrieve" do
    it "GETs /customers/:id and returns an AsaasObject" do
      stub_asaas(:get, "/customers/#{id}", body: customer_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.id).to eq(id)
    end
  end

  describe ".update" do
    it "PUTs to /customers/:id and returns an AsaasObject" do
      updated = customer_attrs.merge("name" => "João Atualizado")
      stub_asaas(:put, "/customers/#{id}", body: updated)

      result = described_class.update(id, name: "João Atualizado")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.name).to eq("João Atualizado")
    end
  end

  describe ".delete" do
    it "DELETEs /customers/:id and returns an AsaasObject" do
      stub_asaas(:delete, "/customers/#{id}", body: { "deleted" => true, "id" => id })

      result = described_class.delete(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.deleted?).to be true
    end
  end

  describe ".list" do
    it "GETs /customers and returns a ListObject" do
      stub_asaas(:get, "/customers", body: list_response([customer_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.total_count).to eq(1)
      expect(result.first.name).to eq("João Silva")
    end
  end

  describe ".restore" do
    it "POSTs to /customers/:id/restore and returns an AsaasObject" do
      stub_asaas(:post, "/customers/#{id}/restore", body: customer_attrs)

      result = described_class.restore(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.id).to eq(id)
    end
  end

  describe ".notifications" do
    it "GETs /customers/:id/notifications and returns a ListObject" do
      notification = { "id" => "not_1", "type" => "EMAIL" }
      stub_asaas(:get, "/customers/#{id}/notifications", body: list_response([notification]))

      result = described_class.notifications(id)

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.type).to eq("EMAIL")
    end
  end
end
