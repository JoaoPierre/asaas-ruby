# frozen_string_literal: true

module Asaas
  module Resources
    class Notification
      extend HasClient

      def self.update(id, params = {}, opts = {})
        response = client(opts).request(:put, "/notifications/#{id}", params: params)
        AsaasObject.construct_from(response)
      end

      def self.update_batch(params = {}, opts = {})
        response = client(opts).request(:put, "/notifications", params: params)
        AsaasObject.construct_from(response)
      end
    end
  end
end
