# frozen_string_literal: true

module Asaas
  module Resources
    class Anticipation < Base
      def self.resource_path = "/anticipations"

      def self.simulate(params = {})
        response = client.request(:post, "#{resource_path}/simulate", params: params)
        AsaasObject.construct_from(response)
      end
    end
  end
end
