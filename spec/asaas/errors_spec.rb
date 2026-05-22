# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::AsaasError do
  describe "#to_s" do
    it "includes only the message when no status or request_id" do
      err = described_class.new("something went wrong")
      expect(err.to_s).to eq("something went wrong")
    end

    it "appends status when present" do
      err = described_class.new("bad", http_status: 400)
      expect(err.to_s).to include("(status=400)")
    end

    it "appends request_id when present" do
      err = described_class.new("bad", request_id: "req_abc")
      expect(err.to_s).to include("[request_id=req_abc]")
    end
  end

  describe "#errors default" do
    it "returns an empty array when no errors given" do
      expect(described_class.new.errors).to eq([])
    end

    it "does not share the default array between instances" do
      a = described_class.new
      b = described_class.new
      a.errors << "x"
      expect(b.errors).to be_empty
    end
  end
end

RSpec.describe "Asaas.error_for_status" do
  subject(:call) { Asaas.error_for_status(status, body, request_id) }

  let(:request_id) { "req_123" }

  context "with an array of errors in the body" do
    let(:status) { 400 }
    let(:body)   { { "errors" => [{ "description" => "campo obrigatorio" }, { "description" => "valor invalido" }] } }

    it "returns InvalidRequestError" do
      expect(call).to be_a(Asaas::InvalidRequestError)
    end

    it "joins descriptions with semicolon" do
      expect(call.message).to include("campo obrigatorio; valor invalido")
    end

    it "exposes the raw errors array" do
      expect(call.errors).to eq(body["errors"])
    end
  end

  context "with a message field in the body" do
    let(:status) { 401 }
    let(:body)   { { "message" => "Invalid API key" } }

    it "returns AuthenticationError with the message" do
      expect(call).to be_a(Asaas::AuthenticationError)
      expect(call.message).to include("Invalid API key")
    end
  end

  context "with an empty body" do
    let(:body) { {} }

    it "falls back to 'Unknown error'" do
      expect(Asaas.error_for_status(403, body, nil).message).to include("Unknown error")
    end
  end

  context "with a non-Hash body" do
    let(:body) { nil }

    it "falls back to 'Unknown error'" do
      expect(Asaas.error_for_status(500, body, nil).message).to include("Unknown error")
    end
  end

  describe "status code mapping" do
    {
      400 => Asaas::InvalidRequestError,
      401 => Asaas::AuthenticationError,
      403 => Asaas::PermissionError,
      404 => Asaas::NotFoundError,
      409 => Asaas::ConflictError,
      422 => Asaas::UnprocessableEntityError,
      429 => Asaas::RateLimitError,
      500 => Asaas::ServerError,
      503 => Asaas::ServerError,
      999 => Asaas::AsaasError
    }.each do |code, klass|
      it "maps #{code} to #{klass}" do
        expect(Asaas.error_for_status(code, {}, nil)).to be_a(klass)
      end
    end
  end
end
