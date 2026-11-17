# frozen_string_literal: true

module Asaas
  module Resources
    # The account's fiscal setup for issuing invoices (NFS-e) and the code tables it uses.
    class FiscalInfo
      extend HasClient

      def self.retrieve(opts = {})
        request_object(:get, "/fiscalInfo/", {}, opts)
      end

      # Creates or updates; the digital certificate goes multipart as an IO.
      def self.save(params = {}, opts = {})
        request_object(:post, "/fiscalInfo/", params, opts)
      end

      def self.configure_national_portal(params = {}, opts = {})
        request_object(:post, "/fiscalInfo/nationalPortal", params, opts)
      end

      def self.municipal_options(opts = {})
        request_object(:get, "/fiscalInfo/municipalOptions", {}, opts)
      end

      def self.services(params = {}, opts = {})
        request_list("/fiscalInfo/services", params, opts)
      end

      def self.federal_service_codes(params = {}, opts = {})
        request_list("/fiscalInfo/federalServiceCodes", params, opts)
      end

      def self.nbs_codes(params = {}, opts = {})
        request_list("/fiscalInfo/nbsCodes", params, opts)
      end

      def self.operation_indicator_codes(params = {}, opts = {})
        request_list("/fiscalInfo/operationIndicatorCodes", params, opts)
      end

      def self.tax_classification_codes(params = {}, opts = {})
        request_list("/fiscalInfo/taxClassificationCodes", params, opts)
      end

      def self.tax_situation_codes(params = {}, opts = {})
        request_list("/fiscalInfo/taxSituationCodes", params, opts)
      end
    end
  end
end
