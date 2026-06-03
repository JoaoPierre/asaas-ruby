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
    end
  end
end
