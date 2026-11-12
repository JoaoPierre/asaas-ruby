# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Finance do
  describe ".balance" do
    it "GETs /finance/balance and returns an AsaasObject" do
      stub_asaas(:get, "/finance/balance", body: { "balance" => 1500.0 })

      result = described_class.balance

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.balance).to eq(1500.0)
    end
  end

  describe ".statistics" do
    it "GETs /finance/payment/statistics and returns an AsaasObject" do
      stub_asaas(:get, "/finance/payment/statistics", body: { "pending" => 3, "received" => 10 })

      result = described_class.statistics

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.received).to eq(10)
    end

    it "forwards filter params" do
      stub = stub_request(:get, "#{ASAAS_BASE_URL}/finance/payment/statistics")
             .with(query: { "billingType" => "PIX" })
             .to_return(status: 200, body: { "received" => 5 }.to_json)

      described_class.statistics(billingType: "PIX")

      expect(stub).to have_been_requested
    end
  end

  describe ".extract" do
    it "GETs /financialTransactions and returns a ListObject" do
      entry = { "object" => "financialTransaction", "id" => "ft_1", "type" => "PAYMENT_RECEIVED",
                "value" => 100.0, "balance" => 1500.0 }
      stub_asaas(:get, "/financialTransactions", body: list_response([entry]))

      result = described_class.extract

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.type).to eq("PAYMENT_RECEIVED")
    end

    it "forwards date range and ordering params" do
      stub = stub_request(:get, "#{ASAAS_BASE_URL}/financialTransactions")
             .with(query: { "startDate" => "2026-11-01", "finishDate" => "2026-11-30", "order" => "desc" })
             .to_return(status: 200, body: list_response([]).to_json)

      described_class.extract(startDate: "2026-11-01", finishDate: "2026-11-30", order: "desc")

      expect(stub).to have_been_requested
    end
  end
end
