# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Subscription do
  let(:id) { "sub_123" }
  let(:subscription_attrs) { { "id" => id, "value" => 49.90, "status" => "ACTIVE", "cycle" => "MONTHLY" } }

  describe ".create" do
    it "POSTs to /subscriptions and returns an AsaasObject" do
      stub_asaas(:post, "/subscriptions", body: subscription_attrs)

      result = described_class.create(customer: "cus_1", value: 49.90, cycle: "MONTHLY", billingType: "PIX")

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.cycle).to eq("MONTHLY")
      expect(result.status).to eq("ACTIVE")
    end
  end

  describe ".retrieve" do
    it "GETs /subscriptions/:id and returns an AsaasObject" do
      stub_asaas(:get, "/subscriptions/#{id}", body: subscription_attrs)

      result = described_class.retrieve(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.value).to eq(49.90)
    end
  end

  describe ".update" do
    it "PUTs to /subscriptions/:id and returns an AsaasObject" do
      updated = subscription_attrs.merge("value" => 59.90)
      stub_asaas(:put, "/subscriptions/#{id}", body: updated)

      result = described_class.update(id, value: 59.90)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.value).to eq(59.90)
    end
  end

  describe ".delete" do
    it "DELETEs /subscriptions/:id" do
      stub_asaas(:delete, "/subscriptions/#{id}", body: { "deleted" => true })

      result = described_class.delete(id)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.deleted?).to be true
    end
  end

  describe ".list" do
    it "GETs /subscriptions and returns a ListObject" do
      stub_asaas(:get, "/subscriptions", body: list_response([subscription_attrs]))

      result = described_class.list

      expect(result).to be_a(Asaas::ListObject)
      expect(result.total_count).to eq(1)
      expect(result.first.cycle).to eq("MONTHLY")
    end
  end

  describe ".payments" do
    it "GETs /subscriptions/:id/payments and returns a ListObject" do
      payment = { "id" => "pay_1", "status" => "RECEIVED", "value" => 49.90 }
      stub_asaas(:get, "/subscriptions/#{id}/payments", body: list_response([payment]))

      result = described_class.payments(id)

      expect(result).to be_a(Asaas::ListObject)
      expect(result.first.status).to eq("RECEIVED")
    end
  end
end
