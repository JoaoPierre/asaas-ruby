# frozen_string_literal: true

module Asaas
  module Resources
    class Anticipation < Base
      def self.resource_path = "/anticipations"

      def self.simulate(params = {}, opts = {})
        response = client(opts).request(:post, "#{resource_path}/simulate", params: params)
        AsaasObject.construct_from(response)
      end

      def self.cancel(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/cancel", {}, opts)
      end

      def self.limits(opts = {})
        request_object(:get, "#{resource_path}/limits", {}, opts)
      end

      # Automatic anticipation status.
      def self.configuration(opts = {})
        request_object(:get, "#{resource_path}/configurations", {}, opts)
      end

      def self.update_configuration(params = {}, opts = {})
        request_object(:put, "#{resource_path}/configurations", params, opts)
      end
    end
  end
end
