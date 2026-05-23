# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Invoice do
  let(:id) { "inv_123" }
  let(:invoice_attrs) { { "id" => id, "status" => "SCHEDULED", "serviceDescription" => "Consultoria" } }

  describe ".create" do
    it "POSTs to /invoices and returns an AsaasObject" do
      stub_asaas(:post, "/invoices", body: invoice_attrs)

      result = described_class.create(payment: "pay_1", serviceDescription: "Consultoria")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("SCHEDULED")
    end
  end

  describe ".retrieve" do
    it "GETs /invoices/:id and returns an AsaasObject" do
      stub_asaas(:get, "/invoices/#{id}", body: invoice_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.serviceDescription).to eq("Consultoria")
    end
  end

  describe ".update" do
    it "PUTs to /invoices/:id and returns an AsaasObject" do
      updated = invoice_attrs.merge("serviceDescription" => "Desenvolvimento")
      stub_asaas(:put, "/invoices/#{id}", body: updated)

      result = described_class.update(id, serviceDescription: "Desenvolvimento")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.serviceDescription).to eq("Desenvolvimento")
    end
  end

  describe ".delete" do
    it "DELETEs /invoices/:id (cancel)" do
      stub_asaas(:delete, "/invoices/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result.deleted?).to be true
    end
  end

  describe ".list" do
    it "GETs /invoices and returns a ListObject" do
      stub_asaas(:get, "/invoices", body: list_response([invoice_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.status).to eq("SCHEDULED")
    end
  end
end
