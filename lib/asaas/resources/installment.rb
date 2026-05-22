# frozen_string_literal: true

module Asaas
  module Resources
    class Installment < Base
      def self.resource_path = "/installments"

      def self.update_splits(id, params = {})
        response = client.request(:put, "#{resource_path}/#{id}/splits", params: params)
        AsaasObject.construct_from(response)
      end
    end
  end
end
