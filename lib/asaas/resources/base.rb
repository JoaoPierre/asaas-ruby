# frozen_string_literal: true

module Asaas
  module Resources
    class Base
      extend HasClient

      def self.resource_path
        raise NotImplementedError, "#{name} must define resource_path"
      end

      def self.create(params = {})
        response = client.request(:post, resource_path, params: params)
        AsaasObject.construct_from(response)
      end

      def self.retrieve(id)
        response = client.request(:get, "#{resource_path}/#{id}")
        AsaasObject.construct_from(response)
      end

      def self.update(id, params = {})
        response = client.request(:put, "#{resource_path}/#{id}", params: params)
        AsaasObject.construct_from(response)
      end

      def self.delete(id)
        response = client.request(:delete, "#{resource_path}/#{id}")
        AsaasObject.construct_from(response)
      end

      def self.list(params = {})
        response = client.request(:get, resource_path, params: params)
        ListObject.construct_from(response, client: client, path: resource_path, params: params)
      end

    end
  end
end
