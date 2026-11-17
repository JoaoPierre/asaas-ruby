# frozen_string_literal: true

module Asaas
  module Resources
    class Webhook < Base
      def self.resource_path = "/webhooks"

      def self.remove_penalty(id, opts = {})
        response = client(opts).request(:post, "#{resource_path}/#{id}/removeBackoff")
        AsaasObject.construct_from(response)
      end

      def self.remove_backoff(id, opts = {}) = remove_penalty(id, opts)
    end
  end
end
