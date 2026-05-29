# frozen_string_literal: true

module Asaas
  module Resources
    class Dunning < Base
      def self.resource_path = "/paymentDunnings"

      def self.resend_documents(id, opts = {})
        response = client(opts).request(:post, "#{resource_path}/#{id}/documents")
        AsaasObject.construct_from(response)
      end
    end
  end
end
