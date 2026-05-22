# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::PaymentLink do
  let(:id) { "lnk_123" }
  let(:link_attrs) { { "id" => id, "name" => "Produto X", "value" => 99.90, "active" => true } }

  describe ".create" do
    it "POSTs to /paymentLinks and returns an AsaasObject" do
      stub_asaas(:post, "/paymentLinks", body: link_attrs)

      result = described_class.create(name: "Produto X", value: 99.90, billingType: "UNDEFINED")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.name).to eq("Produto X")
      expect(result.active?).to be true
    end
  end

  describe ".retrieve" do
    it "GETs /paymentLinks/:id and returns an AsaasObject" do
      stub_asaas(:get, "/paymentLinks/#{id}", body: link_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.value).to eq(99.90)
    end
  end

  describe ".update" do
    it "PUTs to /paymentLinks/:id and returns an AsaasObject" do
      updated = link_attrs.merge("value" => 149.90)
      stub_asaas(:put, "/paymentLinks/#{id}", body: updated)

      result = described_class.update(id, value: 149.90)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.value).to eq(149.90)
    end
  end

  describe ".delete" do
    it "DELETEs /paymentLinks/:id" do
      stub_asaas(:delete, "/paymentLinks/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result.deleted?).to be true
    end
  end

  describe ".list" do
    it "GETs /paymentLinks and returns a ListObject" do
      stub_asaas(:get, "/paymentLinks", body: list_response([link_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.name).to eq("Produto X")
    end
  end

  describe ".add_image" do
    it "POSTs to /paymentLinks/:id/images and returns an AsaasObject" do
      stub_asaas(:post, "/paymentLinks/#{id}/images", body: { "id" => "img_1", "main" => true })

      result = described_class.add_image(id, image: "base64data")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.main?).to be true
    end
  end
end
