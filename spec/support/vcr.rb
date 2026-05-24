# frozen_string_literal: true

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.default_cassette_options = {
    record: ENV.fetch("VCR_RECORD_MODE", "none").to_sym,
    match_requests_on: %i[method uri]
  }

  config.filter_sensitive_data("<ASAAS_API_KEY>") do
    ENV.fetch("ASAAS_API_KEY", "aact_test_fake")
  end
end
