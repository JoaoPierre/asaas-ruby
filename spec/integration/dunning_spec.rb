# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Dunning, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  it "lists dunnings" do
    result = described_class.list

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.total_count).to be_an(Integer)
  end

  it "retrieves a single dunning" do
    list = described_class.list

    skip "no dunnings available" if list.data.empty?

    result = described_class.retrieve(list.data.first.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(list.data.first.id)
  end
end
