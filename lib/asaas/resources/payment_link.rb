# frozen_string_literal: true

module Asaas
  module Resources
    class PaymentLink < Base
      def self.resource_path = "/paymentLinks"

      def self.add_image(id, params = {}, opts = {})
        response = client(opts).request(:post, "#{resource_path}/#{id}/images", params: params)
        AsaasObject.construct_from(response)
      end

      def self.restore(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/restore", {}, opts)
      end

      def self.images(id, params = {}, opts = {})
        request_list("#{resource_path}/#{id}/images", params, opts)
      end

      def self.retrieve_image(id, image_id, opts = {})
        request_object(:get, "#{resource_path}/#{id}/images/#{image_id}", {}, opts)
      end

      def self.delete_image(id, image_id, opts = {})
        request_object(:delete, "#{resource_path}/#{id}/images/#{image_id}", {}, opts)
      end

      def self.set_main_image(id, image_id, opts = {})
        request_object(:put, "#{resource_path}/#{id}/images/#{image_id}/setAsMain", {}, opts)
      end
    end
  end
end
