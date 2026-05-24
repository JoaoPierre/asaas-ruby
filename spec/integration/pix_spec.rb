# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Pix, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  it "lists pix keys" do
    result = described_class.list_keys

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.total_count).to be_an(Integer)
  end

  it "lists pix transactions" do
    result = described_class.transactions

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.total_count).to be_an(Integer)
  end
end
