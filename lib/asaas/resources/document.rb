# frozen_string_literal: true

module Asaas
  module Resources
    # KYC documents for the authenticated (sub)account: /myAccount/documents.
    # All calls act on the account that owns the api_key, so pass the
    # subaccount's own key per call: Document.pending(api_key: "aact_sub_key").
    class Document
      extend HasClient

      def self.resource_path = "/myAccount/documents"

      # Lists pending document groups (each with its onboardingUrl and any
      # files already sent). Returns an AsaasObject with a `data` array.
      def self.pending(opts = {})
        response = client(opts).request(:get, resource_path)
        AsaasObject.construct_from(response)
      end

      # Uploads a file to a document group (multipart). `file` is any IO that
      # responds to #read; `type` is the Asaas document type (e.g. "IDENTIFICATION").
      def self.send_document(group_id, file:, type:, **opts)
        params = { documentFile: file, type: type }
        response = client(opts).request(:post, "#{resource_path}/#{group_id}", params: params)
        AsaasObject.construct_from(response)
      end

      # Removes a previously sent file by its file id.
      def self.delete_file(file_id, opts = {})
        response = client(opts).request(:delete, "#{resource_path}/files/#{file_id}")
        AsaasObject.construct_from(response)
      end
    end
  end
end
