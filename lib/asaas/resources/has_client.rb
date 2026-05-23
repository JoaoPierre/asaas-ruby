# frozen_string_literal: true

module Asaas
  module Resources
    module HasClient
      def self.extended(base)
        base.private_class_method(:client)
      end

      def client
        Client.new
      end
    end
  end
end
