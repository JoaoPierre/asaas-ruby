# frozen_string_literal: true

module Asaas
  module Resources
    class Notification < Base
      def self.update(id, params = {})
        response = client.request(:put, "/notifications/#{id}", params: params)
        AsaasObject.construct_from(response)
      end

      def self.update_batch(params = {})
        response = client.request(:put, "/notifications", params: params)
        AsaasObject.construct_from(response)
      end
    end
  end
end
