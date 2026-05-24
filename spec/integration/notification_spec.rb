# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Notification, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  it "lists notifications for a customer" do
    customer = Asaas::Resources::Customer.create(
      name: "VCR Notification Customer", email: "vcr-notification@test.com", cpfCnpj: "28588369141"
    )
    result = Asaas::Resources::Customer.notifications(customer.id)

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.total_count).to be_an(Integer)
  end

  it "updates a notification" do
    customer = Asaas::Resources::Customer.create(
      name: "VCR Notification Update", email: "vcr-notif-update@test.com", cpfCnpj: "82860600752"
    )
    notifications = Asaas::Resources::Customer.notifications(customer.id)
    notification  = notifications.data.first
    skip "no notifications found for customer" if notification.nil?

    result = described_class.update(notification.id, enabled: false)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(notification.id)
    expect(result.enabled).to eq(false)
  end
end
