# frozen_string_literal: true

module Asaas
  class AsaasObject
    def initialize(attrs = {})
      @attrs = {}
      attrs.to_h.each { |k, v| @attrs[k.to_s] = convert(v) }
    end

    def [](key)
      @attrs[key.to_s]
    end

    def []=(key, value)
      @attrs[key.to_s] = value
    end

    def to_h
      serialize(@attrs)
    end

    def respond_to_missing?(name, include_private = false)
      @attrs.key?(name.to_s.delete_suffix("?")) || super
    end

    def method_missing(name, *args)
      key = name.to_s
      if key.end_with?("?")
        !!@attrs[key.delete_suffix("?")]
      elsif @attrs.key?(key)
        @attrs[key]
      else
        super
      end
    end

    def ==(other)
      case other
      when AsaasObject then to_h == other.to_h
      when Hash        then to_h == other.transform_keys(&:to_s)
      else false
      end
    end

    def inspect
      "#<#{self.class} #{@attrs.inspect}>"
    end

    def self.construct_from(attrs)
      new(attrs)
    end

    private

    def serialize(value)
      case value
      when AsaasObject
        value.to_h
      when Array
        value.map { serialize(_1) }
      when Hash
        value.transform_values { serialize(_1) }
      else
        value
      end
    end

    def convert(value)
      case value
      when Hash  then self.class.new(value)
      when Array then value.map { convert(_1) }
      else value
      end
    end
  end
end
