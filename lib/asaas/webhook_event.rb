# frozen_string_literal: true

require "json"
require "openssl"

module Asaas
  module WebhookEvent
    TOKEN_HEADER = "asaas-access-token"

    def self.construct_event(payload, token_header, expected_token)
      verify_token!(token_header, expected_token)
      AsaasObject.construct_from(JSON.parse(payload))
    rescue JSON::ParserError => e
      raise InvalidPayloadError, "Invalid JSON payload: #{e.message}"
    end

    def self.verify_token!(token_header, expected_token)
      raise ArgumentError, "expected_token cannot be nil or empty" if expected_token.nil? || expected_token.empty?
      raise WebhookVerificationError, "Missing #{TOKEN_HEADER} header" if token_header.nil? || token_header.empty?
      raise WebhookVerificationError, "Token mismatch" unless secure_compare(token_header.to_s, expected_token.to_s)
    end
    private_class_method :verify_token!

    def self.secure_compare(lhs, rhs)
      return false unless lhs.bytesize == rhs.bytesize

      OpenSSL.fixed_length_secure_compare(lhs, rhs)
    end
    private_class_method :secure_compare
  end
end
