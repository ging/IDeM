require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Loop < OmniAuth::Strategies::OAuth2
      option :name, "loop"

      option :client_options, {
        :site => 'https://api.frontiersin.org/v2',
        :authorize_url => 'https://registration.frontiersin.org/oauth2/auth',
        :token_url => 'https://registration.frontiersin.org/oauth2/token'
      }

      option :authorize_params, {
        :scope => "openid profile_read publications_read publications_management",
        :op => "login"
      }
      option :authorize_options, [:scope]

      option :token_params, {}
      option :token_options, []
      option :auth_token_params, {}


      uid {
        loop_data["user_data"]["id"]
      }

      info do
        info = loop_data
        # Only data returned in the info var will be stored in the IDeM database.
        # Filter data.
        info
      end

      def loop_data
        @loop_data ||= {}
        @loop_data["user_data"] ||= access_token.get('me?key=' + IDeM::Application::config.APP_CONFIG["loop"]["oauth2_primary_subscription_key"]).parsed
        @loop_data["publications"] ||= access_token.get('me/publications?key=' + IDeM::Application::config.APP_CONFIG["loop"]["oauth2_primary_subscription_key"]).parsed
        @loop_data["followings"] ||= access_token.get('me/following?key=' + IDeM::Application::config.APP_CONFIG["loop"]["oauth2_primary_subscription_key"]).parsed
        @loop_data["followers"] ||= access_token.get('me/followers?key=' + IDeM::Application::config.APP_CONFIG["loop"]["oauth2_primary_subscription_key"]).parsed
        @loop_data
      end


      def request_phase
        redirect client.auth_code.authorize_url({:redirect_uri => callback_url}.merge(authorize_params))
      end

      def authorize_params
        options.authorize_params[:state] = SecureRandom.hex(24)
        params = options.authorize_params.merge(options_for("authorize"))
        if OmniAuth.config.test_mode
          @env ||= {}
          @env["rack.session"] ||= {}
        end
        session["omniauth.state"] = params[:state]
        params
      end

      def token_params
        options.token_params.merge(options_for("token")).merge(:headers => {'Authorization' => basic_auth_header })
      end

      def basic_auth_header
        "Basic " + Base64.strict_encode64("#{options[:client_id]}:#{options[:client_secret]}")
      end


      protected

      def build_access_token
        verifier = request.params["code"]
        accessToken = client.auth_code.get_token(verifier, {:redirect_uri => callback_url}.merge(token_params.to_hash(:symbolize_keys => true)), deep_symbolize(options.auth_token_params))
        accessToken
      end

    end
  end
end