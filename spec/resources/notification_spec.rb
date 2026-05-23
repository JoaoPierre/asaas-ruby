# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Notification do
  let(:id) { "not_123" }
  let(:notification_attrs) { { "id" => id, "enabled" => true, "emailEnabledForProvider" => false } }

  describe ".update" do
    it "PUTs to /notifications/:id and returns an AsaasObject" do
      stub_asaas(:put, "/notifications/#{id}", body: notification_attrs.merge("enabled" => false))

      result = described_class.update(id, enabled: false)

      expect(result).to be_a(Asaas::AsaasObject)
      expect(result.enabled?).to be false
    end
  end

  describe ".update_batch" do
    it "PUTs to /notifications and returns an AsaasObject" do
      batch_response = { "notifications" => [notification_attrs] }
      stub_asaas(:put, "/notifications", body: batch_response)

      result = described_class.update_batch(notifications: [{ id: id, enabled: true }])

      expect(result).to be_a(Asaas::AsaasObject)
    end
  end
end
