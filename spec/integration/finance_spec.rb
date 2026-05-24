# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Finance, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  it "returns payment statistics" do
    result = described_class.statistics

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.quantity).to be_a(Integer)
    expect(result.value).to be_a(Numeric)
    expect(result.netValue).to be_a(Numeric)
  end
end
