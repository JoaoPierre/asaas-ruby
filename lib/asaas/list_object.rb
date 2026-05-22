# frozen_string_literal: true

module Asaas
  class ListObject
    include Enumerable

    attr_reader :data, :has_more, :total_count, :limit, :offset

    def initialize(attrs, client:, path:, params: {})
      @data        = Array(attrs["data"]).map { AsaasObject.construct_from(_1) }
      @has_more    = attrs["hasMore"] || false
      @total_count = attrs["totalCount"]
      @limit       = attrs["limit"]
      @offset      = attrs["offset"] || 0
      @client      = client
      @path        = path
      @params      = params
    end

    def each(&block)
      @data.each(&block)
    end

    def next_page
      return nil unless @has_more

      next_params = @params.merge("offset" => @offset + @limit, "limit" => @limit)
      raw = @client.request(:get, @path, params: next_params)
      self.class.new(raw, client: @client, path: @path, params: next_params)
    end

    def auto_paging_each(&block)
      return enum_for(:auto_paging_each) unless block

      page = self
      loop do
        page.each(&block)
        break unless page.has_more

        page = page.next_page
      end
    end

    def self.construct_from(attrs, client:, path:, params: {})
      new(attrs, client: client, path: path, params: params)
    end

    def inspect
      "#<#{self.class} total_count=#{@total_count} has_more=#{@has_more} data=#{@data.inspect}>"
    end
  end
end
