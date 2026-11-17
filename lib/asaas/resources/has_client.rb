# frozen_string_literal: true

module Asaas
  module Resources
    module HasClient
      def self.extended(base)
        base.private_class_method(:client, :request_options, :request_object, :request_list, :request_raw)
      end

      def client(opts = {})
        Client.new(api_key: opts[:api_key])
      end

      # Per-call transport options every request accepts: retry and timeout.
      def request_options(opts = {})
        { retryable: opts.fetch(:retryable, true), timeout: opts[:timeout] }
      end

      # One request that answers a single object. Mutating calls also take opts[:idempotency_key].
      def request_object(method, path, params = {}, opts = {})
        response = client(opts).request(method, path, params: params, idempotency_key: opts[:idempotency_key],
                                                      **request_options(opts))
        AsaasObject.construct_from(response)
      end

      # A paginated GET; the ListObject keeps the options for every next page.
      def request_list(path, params = {}, opts = {})
        response = client(opts).request(:get, path, params: params, **request_options(opts))
        ListObject.construct_from(response, client: client(opts), path: path, params: params,
                                            request_options: request_options(opts))
      end

      # A GET that answers a file (PDF) instead of JSON: returns the body as a binary String.
      def request_raw(path, params = {}, opts = {})
        client(opts).request(:get, path, params: params, headers: { "Accept" => "application/pdf" }, raw: true,
                                         **request_options(opts))
      end
    end
  end
end
