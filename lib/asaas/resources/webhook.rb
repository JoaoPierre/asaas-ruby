# frozen_string_literal: true

module Asaas
  module Resources
    class Webhook < Base
      def self.resource_path = "/webhooks"

      def self.remove_penalty(id)
        response = client.request(:post, "#{resource_path}/#{id}/removePenalty")
        AsaasObject.construct_from(response)
      end
    end
  end
end
