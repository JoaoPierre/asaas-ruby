# frozen_string_literal: true

require "spec_helper"
require "webmock/rspec"

RSpec.describe Asaas::Client do
  let(:api_key) { "aact_test_fake" }
  let(:base_url) { "https://sandbox.asaas.com/api/v3" }

  before do
    Asaas.configure do |c|
      c.api_key     = api_key
      c.sandbox     = true
      c.max_retries = 0
    end
  end

  subject(:client) { described_class.new }

  describe "#request" do
    context "GET" do
      it "returns parsed JSON body on success" do
        stub_request(:get, "#{base_url}/customers")
          .to_return(status: 200, body: { "totalCount" => 1 }.to_json, headers: { "Content-Type" => "application/json" })

        result = client.request(:get, "/customers")

        expect(result).to eq({ "totalCount" => 1 })
      end

      it "appends query params to the URL" do
        stub = stub_request(:get, "#{base_url}/customers")
               .with(query: { "name" => "João" })
               .to_return(status: 200, body: {}.to_json)

        client.request(:get, "/customers", params: { name: "João" })

        expect(stub).to have_been_requested
      end

      it "flattens nested query params" do
        stub = stub_request(:get, "#{base_url}/payments")
               .with(query: { "filter[status]" => "PENDING" })
               .to_return(status: 200, body: {}.to_json)

        client.request(:get, "/payments", params: { filter: { status: "PENDING" } })

        expect(stub).to have_been_requested
      end
    end

    context "POST" do
      it "sends body as JSON" do
        stub = stub_request(:post, "#{base_url}/customers")
               .with(body: { "name" => "Maria" })
               .to_return(status: 200, body: { "id" => "cus_1" }.to_json)

        result = client.request(:post, "/customers", params: { name: "Maria" })

        expect(result["id"]).to eq("cus_1")
        expect(stub).to have_been_requested
      end

      it "sends an Idempotency-Key header" do
        stub = stub_request(:post, "#{base_url}/customers")
               .with(headers: { "Idempotency-Key" => /\S+/ })
               .to_return(status: 200, body: {}.to_json)

        client.request(:post, "/customers", params: {})

        expect(stub).to have_been_requested
      end

      it "reuses the same Idempotency-Key across retries" do
        Asaas.configure do |c|
          c.api_key     = api_key
          c.sandbox     = true
          c.max_retries = 1
          c.retry_delay = 0
        end

        received_keys = []

        stub_request(:post, "#{base_url}/customers")
          .to_return do |req|
            received_keys << req.headers["Idempotency-Key"]
            received_keys.size == 1 ? { status: 500, body: {}.to_json } : { status: 200, body: {}.to_json }
          end

        client.request(:post, "/customers", params: {})

        expect(received_keys.size).to eq(2)
        expect(received_keys.uniq.size).to eq(1)
      end
    end

    context "authentication" do
      it "sends access_token header" do
        stub = stub_request(:get, "#{base_url}/customers")
               .with(headers: { "access_token" => api_key })
               .to_return(status: 200, body: {}.to_json)

        client.request(:get, "/customers")

        expect(stub).to have_been_requested
      end
    end

    context "error responses" do
      it "raises AuthenticationError on 401" do
        stub_request(:get, "#{base_url}/customers")
          .to_return(status: 401, body: { "errors" => [{ "description" => "Invalid API key" }] }.to_json)

        expect { client.request(:get, "/customers") }.to raise_error(Asaas::AuthenticationError)
      end

      it "raises NotFoundError on 404" do
        stub_request(:get, "#{base_url}/customers/notfound")
          .to_return(status: 404, body: {}.to_json)

        expect { client.request(:get, "/customers/notfound") }.to raise_error(Asaas::NotFoundError)
      end

      it "raises ServerError on 500" do
        stub_request(:get, "#{base_url}/customers")
          .to_return(status: 500, body: {}.to_json)

        expect { client.request(:get, "/customers") }.to raise_error(Asaas::ServerError)
      end

      it "raises ConnectionError on network failure" do
        stub_request(:get, "#{base_url}/customers").to_raise(SocketError)

        expect { client.request(:get, "/customers") }.to raise_error(Asaas::ConnectionError)
      end

      it "handles empty response body" do
        stub_request(:delete, "#{base_url}/customers/cus_1")
          .to_return(status: 200, body: "")

        expect { client.request(:delete, "/customers/cus_1") }.not_to raise_error
      end
    end

    context "retries" do
      before do
        Asaas.configure do |c|
          c.api_key     = api_key
          c.sandbox     = true
          c.max_retries = 2
          c.retry_delay = 0
        end
      end

      it "retries on 500 and succeeds" do
        stub_request(:get, "#{base_url}/customers")
          .to_return(status: 500, body: {}.to_json).then
          .to_return(status: 200, body: { "ok" => true }.to_json)

        result = client.request(:get, "/customers")

        expect(result["ok"]).to be true
      end

      it "raises after exhausting retries" do
        stub_request(:get, "#{base_url}/customers")
          .to_return(status: 500, body: {}.to_json).times(3)

        expect { client.request(:get, "/customers") }.to raise_error(Asaas::ServerError)
      end

      it "does not retry on 404" do
        stub_request(:get, "#{base_url}/customers")
          .to_return(status: 404, body: {}.to_json)

        begin
          client.request(:get, "/customers")
        rescue StandardError
          nil
        end

        expect(WebMock).to have_requested(:get, "#{base_url}/customers").once
      end
    end

    context "configuration" do
      it "raises ConfigurationError when api_key is nil" do
        Asaas.configure { |c| c.api_key = nil }

        expect { client.request(:get, "/customers") }.to raise_error(Asaas::ConfigurationError)
      end

      it "raises ConfigurationError when api_key is empty" do
        Asaas.configure { |c| c.api_key = "" }

        expect { client.request(:get, "/customers") }.to raise_error(Asaas::ConfigurationError)
      end
    end
  end
end
