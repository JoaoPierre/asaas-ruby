# frozen_string_literal: true

module Asaas
  module Resources
    class Dunning < Base
      def self.resource_path = "/dunnings"

      def self.resend_documents(id)
        response = client.request(:post, "#{resource_path}/#{id}/documents")
        AsaasObject.construct_from(response)
      end
    end
  end
end
