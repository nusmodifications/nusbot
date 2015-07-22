require 'multi_json'
require 'rest_client'

module NUSBotgram
  module Wit
    class WitEngine
      API_ENDPOINT = 'https://api.wit.ai'

      def initialize(access_token, expected_version = nil)
        unless expected_version.nil? || expected_version =~ /\d/
          raise ArgumentError "expected_version must be nil or 'YYYYMMDD' date format"
        end

        @access_token = access_token
        @expected_version = expected_version
      end

      public

      def message(query, context = nil, meta = nil)
        params = { q: query, context: context, meta: meta }
        headers = default_headers.merge(params: params)
        response = api['message'].get(headers)

        MultiJson.load(response)
      end

      private

      def default_headers
        unless @default_headers
          @default_headers = { Authorization: "Bearer #{@access_token}" }

          unless @expected_version.nil?
            @default_headers.merge!(Accept: "application/vnd.wit.#{@expected_version}")
          end
        end

        @default_headers
      end

      private

      def api
        @api ||= RestClient::Resource.new API_ENDPOINT
      end
    end
  end
end