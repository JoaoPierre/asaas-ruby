# frozen_string_literal: true

module Asaas
  module Resources
    module HasClient
      def self.extended(base)
        base.private_class_method(:client, :request_options)
      end

      def client(opts = {})
        Client.new(api_key: opts[:api_key])
      end

      # Per-call transport options every request accepts: retry and timeout.
      def request_options(opts = {})
        { retryable: opts.fetch(:retryable, true), timeout: opts[:timeout] }
      end
    end
  end
end
