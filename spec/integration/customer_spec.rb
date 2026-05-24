# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::Resources::Customer, :vcr do
  before do
    Asaas.configure do |c|
      c.api_key = ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
      c.sandbox = true
    end
  end

  it "creates a customer" do
    result = described_class.create(name: "VCR Test Create", email: "vcr-create@test.com", cpfCnpj: "52998224725")

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.object).to eq("customer")
    expect(result.id).to start_with("cus_")
    expect(result.name).to eq("VCR Test Create")
    expect(result.email).to eq("vcr-create@test.com")
    expect(result.cpfCnpj).to eq("52998224725")
    expect(result.personType).to eq("FISICA")
    expect(result.deleted).to eq(false)
    expect(result.country).to eq("Brasil")
    expect(result.dateCreated).not_to be_nil
  end

  it "retrieves a customer" do
    created = described_class.create(name: "VCR Test Retrieve", email: "vcr-retrieve@test.com", cpfCnpj: "12345678909")
    result  = described_class.retrieve(created.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.object).to eq("customer")
    expect(result.id).to eq(created.id)
    expect(result.name).to eq("VCR Test Retrieve")
    expect(result.email).to eq("vcr-retrieve@test.com")
    expect(result.cpfCnpj).to eq("12345678909")
    expect(result.deleted).to eq(false)
  end

  it "lists customers and returns a ListObject" do
    result = described_class.list(limit: 5)

    expect(result).to be_a(Asaas::ListObject)
    expect(result.data).to be_an(Array)
    expect(result.limit).to eq(5)
    expect(result.offset).to eq(0)
    expect(result.total_count).to be_an(Integer)
    expect(result.has_more).to be(true).or be(false)
  end

  it "updates a customer" do
    created = described_class.create(name: "VCR Test Update", email: "vcr-update@test.com", cpfCnpj: "71428793860")
    result  = described_class.update(created.id, name: "VCR Test Updated")

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.object).to eq("customer")
    expect(result.id).to eq(created.id)
    expect(result.name).to eq("VCR Test Updated")
    expect(result.email).to eq("vcr-update@test.com")
    expect(result.deleted).to eq(false)
  end

  it "deletes a customer" do
    created = described_class.create(name: "VCR Test Delete", email: "vcr-delete@test.com", cpfCnpj: "11144477735")
    result  = described_class.delete(created.id)

    expect(result).to be_a(Asaas::AsaasObject)
    expect(result.id).to eq(created.id)
    expect(result.deleted).to eq(true)
  end
end
