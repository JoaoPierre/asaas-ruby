# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::PixAutomatic, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  it "lists pix automatic authorizations" do
    skip "requires Pix Automático feature enabled by Asaas account manager"

    result = described_class.list

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.total_count).to be_an(Integer)
  end
end
