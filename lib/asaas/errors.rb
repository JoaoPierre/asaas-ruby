# frozen_string_literal: true

module Asaas
  class AsaasError < StandardError
    attr_reader :http_status, :http_body, :request_id, :errors

    def initialize(message = nil, http_status: nil, http_body: nil, request_id: nil, errors: nil)
      super(message)
      @http_status = http_status
      @http_body   = http_body
      @request_id  = request_id
      @errors      = errors || []
    end

    def to_s
      msg = super
      msg += " (status=#{http_status})" if http_status
      msg += " [request_id=#{request_id}]" if request_id
      msg
    end
  end

  # 400
  class InvalidRequestError      < AsaasError; end
  # 401
  class AuthenticationError      < AsaasError; end
  # 403
  class PermissionError          < AsaasError; end
  # 404
  class NotFoundError            < AsaasError; end
  # 409
  class ConflictError            < AsaasError; end
  # 422
  class UnprocessableEntityError < AsaasError; end
  # 429
  class RateLimitError           < AsaasError; end
  # 5xx
  class ServerError              < AsaasError; end
  # network
  class ConnectionError          < AsaasError; end
  # sdk config
  class ConfigurationError       < AsaasError; end
  # webhook token missing or mismatched
  class WebhookVerificationError < AsaasError; end
  # webhook payload is not valid JSON
  class InvalidPayloadError      < AsaasError; end

  def self.error_for_status(http_status, http_body, request_id)
    message = extract_message(http_body)
    errors = extract_errors(http_body)
    kwargs = { http_status:, http_body:, request_id:, errors: }

    case http_status
    when 400 then InvalidRequestError.new(message, **kwargs)
    when 401 then AuthenticationError.new(message, **kwargs)
    when 403 then PermissionError.new(message, **kwargs)
    when 404 then NotFoundError.new(message, **kwargs)
    when 409 then ConflictError.new(message, **kwargs)
    when 422 then UnprocessableEntityError.new(message, **kwargs)
    when 429 then RateLimitError.new(message, **kwargs)
    when 500..599 then ServerError.new(message, **kwargs)
    else AsaasError.new(message, **kwargs)
    end
  end

  def self.extract_message(body)
    return "Unknown error" unless body.is_a?(Hash)

    if body["errors"].is_a?(Array) && body["errors"].any?
      body["errors"].filter_map { _1["description"] }.join("; ")
    else
      body["message"] || "Unknown error"
    end
  end
  private_class_method :extract_message

  def self.extract_errors(body)
    return [] unless body.is_a?(Hash) && body["errors"].is_a?(Array)

    body["errors"]
  end
  private_class_method :extract_errors
end
