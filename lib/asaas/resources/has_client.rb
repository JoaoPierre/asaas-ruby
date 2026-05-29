# frozen_string_literal: true

module Asaas
  module Resources
    module HasClient
      def self.extended(base)
        base.private_class_method(:client)
      end

      def client(opts = {})
        Client.new(api_key: opts[:api_key])
      end
    end
  end
end
