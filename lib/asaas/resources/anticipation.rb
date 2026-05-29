# frozen_string_literal: true

module Asaas
  module Resources
    class Anticipation < Base
      def self.resource_path = "/anticipations"

      def self.simulate(params = {}, opts = {})
        response = client(opts).request(:post, "#{resource_path}/simulate", params: params)
        AsaasObject.construct_from(response)
      end
    end
  end
end
