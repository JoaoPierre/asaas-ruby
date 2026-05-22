# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Payment do
  let(:id) { "pay_123" }
  let(:payment_attrs) { { "id" => id, "value" => 100.0, "status" => "PENDING" } }

  describe ".create" do
    it "POSTs to /payments and returns an AsaasObject" do
      stub_asaas(:post, "/payments", body: payment_attrs)

      result = described_class.create(customer: "cus_1", value: 100.0, billingType: "PIX")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("PENDING")
    end
  end

  describe ".retrieve" do
    it "GETs /payments/:id and returns an AsaasObject" do
      stub_asaas(:get, "/payments/#{id}", body: payment_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.value).to eq(100.0)
    end
  end

  describe ".list" do
    it "GETs /payments and returns a ListObject" do
      stub_asaas(:get, "/payments", body: list_response([payment_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.status).to eq("PENDING")
    end
  end

  describe ".restore" do
    it "POSTs to /payments/:id/restore" do
      stub_asaas(:post, "/payments/#{id}/restore", body: payment_attrs)

      result = described_class.restore(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.id).to eq(id)
    end
  end

  describe ".refund" do
    it "POSTs to /payments/:id/refund" do
      refunded = payment_attrs.merge("status" => "REFUNDED")
      stub_asaas(:post, "/payments/#{id}/refund", body: refunded)

      result = described_class.refund(id, value: 100.0)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("REFUNDED")
    end
  end

  describe ".capture" do
    it "POSTs to /payments/:id/capture" do
      stub_asaas(:post, "/payments/#{id}/capture", body: payment_attrs.merge("status" => "CONFIRMED"))

      result = described_class.capture(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("CONFIRMED")
    end
  end

  describe ".confirm_cash_receipt" do
    it "POSTs to /payments/:id/confirmCashReceipt" do
      stub_asaas(:post, "/payments/#{id}/confirmCashReceipt", body: payment_attrs.merge("status" => "RECEIVED"))

      result = described_class.confirm_cash_receipt(id, paymentDate: "2025-01-01")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.status).to eq("RECEIVED")
    end
  end

  describe ".payment_info" do
    it "GETs /payments/:id/paymentInfo" do
      info = { "bankSlipUrl" => "https://example.com/boleto", "expirationDate" => "2025-12-31" }
      stub_asaas(:get, "/payments/#{id}/paymentInfo", body: info)

      result = described_class.payment_info(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.bankSlipUrl).to eq("https://example.com/boleto")
    end
  end
end
