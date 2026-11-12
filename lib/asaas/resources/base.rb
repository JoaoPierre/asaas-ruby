# frozen_string_literal: true

module Asaas
  module Resources
    class Base
      extend HasClient

      def self.resource_path
        raise NotImplementedError, "#{name} must define resource_path"
      end

      def self.create(params = {}, opts = {})
        response = client(opts).request(
          :post,
          resource_path,
          params: params,
          idempotency_key: opts[:idempotency_key],
          **request_options(opts)
        )
        AsaasObject.construct_from(response)
      end

      def self.retrieve(id, opts = {})
        response = client(opts).request(:get, "#{resource_path}/#{id}", **request_options(opts))
        AsaasObject.construct_from(response)
      end

      def self.update(id, params = {}, opts = {})
        response = client(opts).request(:put, "#{resource_path}/#{id}", params: params, **request_options(opts))
        AsaasObject.construct_from(response)
      end

      def self.delete(id, opts = {})
        response = client(opts).request(:delete, "#{resource_path}/#{id}", **request_options(opts))
        AsaasObject.construct_from(response)
      end

      def self.list(params = {}, opts = {})
        response = client(opts).request(:get, resource_path, params: params, **request_options(opts))
        ListObject.construct_from(response, client: client(opts), path: resource_path, params: params,
                                            request_options: request_options(opts))
      end
    end
  end
end
