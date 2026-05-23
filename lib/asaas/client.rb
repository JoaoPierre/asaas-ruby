# frozen_string_literal: true

require "net/http"
require "uri"
require "json"
require "securerandom"

module Asaas
  class Client
    RETRY_STATUSES     = [429, 500, 502, 503, 504].freeze
    IDEMPOTENT_METHODS = %i[post put patch].freeze

    def initialize(config = Asaas.config)
      @config = config
    end

    # @param method  [:get, :post, :put, :patch, :delete]
    # @param path    [String]
    # @param params  [Hash]
    # @param headers [Hash]
    # @return [Hash]
    def request(method, path, params: {}, headers: {})
      validate_config!

      uri  = build_uri(path, method == :get ? params : {})
      body = method != :get ? params : {}

      with_retries do
        perform(method, uri, body, build_headers(method, headers))
      end
    end

    private

    def validate_config!
      return unless @config.api_key.nil? || @config.api_key.empty?

      raise ConfigurationError, "Asaas.api_key is not set. Call Asaas.configure { |c| c.api_key = '...' }"
    end

    def build_uri(path, query_params = {})
      uri = URI.parse("#{@config.base_url}#{path}")
      uri.query = URI.encode_www_form(flatten_params(query_params)) if query_params.any?
      uri
    end

    def build_headers(method, extra = {})
      headers = {
        "Content-Type" => "application/json",
        "Accept" => "application/json",
        "access_token" => @config.api_key,
        "User-Agent" => "AsaasRuby/#{Asaas::VERSION}"
      }
      headers["Idempotency-Key"] = SecureRandom.uuid if IDEMPOTENT_METHODS.include?(method)
      headers.merge(extra)
    end

    def perform(method, uri, body, headers)
      http              = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl      = uri.scheme == "https"
      http.read_timeout = @config.timeout
      http.open_timeout = @config.timeout

      req = build_request(method, uri, headers, body)

      log_request(method, uri, body)

      res = begin
        http.request(req)
      rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT,
             Net::OpenTimeout, Net::ReadTimeout, SocketError => e
        raise ConnectionError, "Network error: #{e.message}"
      end

      log_response(res)
      parse_response(res)
    end

    def build_request(method, uri, headers, body)
      klass = {
        get: Net::HTTP::Get,
        post: Net::HTTP::Post,
        put: Net::HTTP::Put,
        patch: Net::HTTP::Patch,
        delete: Net::HTTP::Delete
      }.fetch(method)

      req      = klass.new(uri.request_uri, headers)
      req.body = JSON.generate(body) if body.any?
      req
    end

    def parse_response(res)
      status     = res.code.to_i
      request_id = res["X-Request-Id"]
      body       = parse_body(res.body)

      raise Asaas.error_for_status(status, body, request_id) unless (200..299).cover?(status)

      body
    end

    def parse_body(raw)
      return {} if raw.nil? || raw.empty?

      JSON.parse(raw)
    rescue JSON::ParserError
      {}
    end

    def with_retries
      attempts = 0
      begin
        yield
      rescue RateLimitError, ServerError, ConnectionError => e
        attempts += 1
        if attempts <= @config.max_retries && retryable?(e)
          sleep(@config.retry_delay * (2**(attempts - 1)))
          retry
        end
        raise
      end
    end

    def retryable?(error)
      case error
      in ConnectionError | RateLimitError then true
      in ServerError if RETRY_STATUSES.include?(error.http_status) then true
      else false
      end
    end

    # TODO: Array values (e.g. { ids: [1,2,3] }) are not serialized
    # revisit if any endpoint needs array query params
    def flatten_params(params, prefix = nil)
      params.each_with_object({}) do |(k, v), result|
        key = prefix ? "#{prefix}[#{k}]" : k.to_s
        if v.is_a?(Hash)
          result.merge!(flatten_params(v, key))
        else
          result[key] = v
        end
      end
    end

    def log_request(method, uri, body)
      return unless @config.logger

      @config.logger.debug("[Asaas] --> #{method.upcase} #{uri}#{body.any? ? " #{body.to_json}" : ""}")
    end

    def log_response(res)
      return unless @config.logger

      @config.logger.debug("[Asaas] <-- #{res.code} #{res.body&.slice(0, 200)}")
    end
  end
end
