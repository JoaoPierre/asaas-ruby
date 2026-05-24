# frozen_string_literal: true

require "asaas"
require "webmock/rspec"
require_relative "support/vcr"

ASAAS_BASE_URL = "https://sandbox.asaas.com/api/v3"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before do
    Asaas.configure do |c|
      c.api_key     = "aact_test_fake"
      c.sandbox     = true
      c.max_retries = 0
    end
  end
end

def stub_asaas(method, path, body: {}, status: 200)
  stub_request(method, "#{ASAAS_BASE_URL}#{path}")
    .to_return(
      status: status,
      body: body.to_json,
      headers: { "Content-Type" => "application/json" }
    )
end

def list_response(items, has_more: false)
  {
    "object" => "list",
    "hasMore" => has_more,
    "totalCount" => items.size,
    "limit" => 10,
    "offset" => 0,
    "data" => items
  }
end
