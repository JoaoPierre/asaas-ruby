# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Split, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  it "lists paid splits" do
    result = described_class.paid

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.total_count).to be_an(Integer)
  end

  it "lists received splits" do
    result = described_class.received

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.total_count).to be_an(Integer)
  end
end
