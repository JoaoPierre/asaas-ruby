# frozen_string_literal: true

module Asaas
  class Configuration
    PRODUCTION_URL = "https://api.asaas.com/v3"
    SANDBOX_URL    = "https://sandbox.asaas.com/api/v3"

    DEFAULT_TIMEOUT     = 30
    DEFAULT_MAX_RETRIES = 2
    DEFAULT_RETRY_DELAY = 0.5

    attr_accessor :api_key,
                  :sandbox,
                  :timeout,
                  :max_retries,
                  :retry_delay,
                  :logger

    def initialize
      @sandbox     = false
      @timeout     = DEFAULT_TIMEOUT
      @max_retries = DEFAULT_MAX_RETRIES
      @retry_delay = DEFAULT_RETRY_DELAY
      @logger      = nil
    end

    def base_url
      sandbox ? SANDBOX_URL : PRODUCTION_URL
    end
  end
end
