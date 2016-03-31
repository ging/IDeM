require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Loop < OmniAuth::Strategies::OAuth2
      option :name, "Loop"

      option :client_options, {
        :site => 'https://loop.frontiersin.org',
        :authorize_url => 'https://registration.frontiersin.org/oauth2/auth',
        :token_url => 'https://registration.frontiersin.org/oauth2/token'
      }

      uid { user_data['id'] }

      info do
        {
          'email' => user_data['email'],
          'name' => user_data['name']
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def user_data
        access_token.options[:mode] = :query
        user_data ||= access_token.get('/me').parsed
      end

    end
  end
end