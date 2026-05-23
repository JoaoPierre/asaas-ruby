# frozen_string_literal: true

require "spec_helper"

RSpec.describe Asaas::WebhookEvent do
  let(:token)   { "my_webhook_secret" }
  let(:event)   { { "event" => "PAYMENT_RECEIVED", "payment" => { "id" => "pay_123", "status" => "RECEIVED" } } }
  let(:payload) { event.to_json }

  describe ".construct_event" do
    context "with valid token and payload" do
      it "returns an AsaasObject" do
        result = described_class.construct_event(payload, token, token)

        expect(result).to be_a(Asaas::AsaasObject)
      end

      it "exposes top-level fields via dot notation" do
        result = described_class.construct_event(payload, token, token)

        expect(result.event).to eq("PAYMENT_RECEIVED")
      end

      it "exposes nested fields as AsaasObject" do
        result = described_class.construct_event(payload, token, token)

        expect(result.payment).to be_a(Asaas::AsaasObject)
        expect(result.payment.id).to eq("pay_123")
        expect(result.payment.status).to eq("RECEIVED")
      end
    end

    context "when token header is nil" do
      it "raises WebhookVerificationError" do
        expect { described_class.construct_event(payload, nil, token) }
          .to raise_error(Asaas::WebhookVerificationError, /Missing asaas-access-token/)
      end
    end

    context "when token header is empty" do
      it "raises WebhookVerificationError" do
        expect { described_class.construct_event(payload, "", token) }
          .to raise_error(Asaas::WebhookVerificationError, /Missing asaas-access-token/)
      end
    end

    context "when token header does not match expected token" do
      it "raises WebhookVerificationError" do
        expect { described_class.construct_event(payload, "wrong_token", token) }
          .to raise_error(Asaas::WebhookVerificationError, /Token mismatch/)
      end
    end

    context "when payload is not valid JSON" do
      it "raises InvalidPayloadError" do
        expect { described_class.construct_event("not json {", token, token) }
          .to raise_error(Asaas::InvalidPayloadError, /Invalid JSON payload/)
      end
    end
  end
end
