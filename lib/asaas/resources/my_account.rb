# frozen_string_literal: true

module Asaas
  module Resources
    # The authenticated (sub)account itself: /myAccount.
    # Acts on the account that owns the api_key, so pass the subaccount's own
    # key per call: MyAccount.status(api_key: "aact_sub_key").
    class MyAccount
      extend HasClient

      # Authoritative KYC registration status. Returns an AsaasObject exposing
      # commercialInfo, documentation, bankAccountInfo and general statuses.
      def self.status(opts = {})
        response = client(opts).request(:get, "/myAccount/status")
        AsaasObject.construct_from(response)
      end

      def self.commercial_info(opts = {})
        response = client(opts).request(:get, "/myAccount/commercialInfo/")
        AsaasObject.construct_from(response)
      end

      def self.update_commercial_info(profile, opts = {})
        response = client(opts).request(
          :post,
          "/myAccount/commercialInfo/",
          params: profile,
          retryable: opts.fetch(:retryable, true)
        )
        AsaasObject.construct_from(response)
      end

      def self.account_number(opts = {})
        request_object(:get, "/myAccount/accountNumber", {}, opts)
      end

      def self.fees(opts = {})
        request_object(:get, "/myAccount/fees/", {}, opts)
      end

      def self.wallets(opts = {})
        request_list("/wallets/", {}, opts)
      end

      # Invoice page customization (logo and colors; the logo goes multipart as an IO).
      def self.payment_checkout_config(opts = {})
        request_object(:get, "/myAccount/paymentCheckoutConfig/", {}, opts)
      end

      def self.update_payment_checkout_config(params = {}, opts = {})
        request_object(:post, "/myAccount/paymentCheckoutConfig/", params, opts)
      end

      # Deletes the White Label subaccount that owns the api_key: params { removeReason: "..." }.
      def self.delete_white_label(params = {}, opts = {})
        query = params.empty? ? "" : "?#{URI.encode_www_form(params)}"
        request_object(:delete, "/myAccount/#{query}", {}, opts)
      end
    end
  end
end
