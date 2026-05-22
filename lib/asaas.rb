# frozen_string_literal: true

require_relative "asaas/version"
require_relative "asaas/configuration"
require_relative "asaas/errors"
require_relative "asaas/asaas_object"
require_relative "asaas/list_object"
require_relative "asaas/client"
require_relative "asaas/resources/base"
require_relative "asaas/resources/customer"
require_relative "asaas/resources/payment"
require_relative "asaas/resources/subscription"
require_relative "asaas/resources/webhook"
require_relative "asaas/resources/finance"
require_relative "asaas/resources/installment"

module Asaas
  @config = Configuration.new

  class << self
    attr_reader :config

    def configure
      yield @config
    end

    def api_key=(key)
      @config.api_key = key
    end

    def api_key
      @config.api_key
    end

    def sandbox=(val)
      @config.sandbox = val
    end

    def sandbox?
      @config.sandbox
    end
  end
end
