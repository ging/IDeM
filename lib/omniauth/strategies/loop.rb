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
        user_data["id"]
      }

      info do
        info = {}

        info["name"] = user_data["firstName"]
        info["name"] += (" " + user_data["lastName"]) unless user_data["lastName"].blank?

        info["loop_id"] = user_data["id"]
        info["loop_profile_url"] = user_data["profileUrl"]

        unless user_data["country"].blank?
          case user_data["country"].downcase
          when "spain"
            info["language"] = "es"
          else
            info["language"] = I18n.locale.to_s
          end
        end

        info["publications"] = user_data["publications"] unless user_data["publications"].nil?

        info
      end

      def user_data
        @user_data ||= access_token.get('me?key=' + IDeM::Application::config.APP_CONFIG["loop"]["oauth2_primary_subscription_key"]).parsed
        @user_data["publications"] ||= access_token.get('me/publications?key=' + IDeM::Application::config.APP_CONFIG["loop"]["oauth2_primary_subscription_key"]).parsed
        @user_data
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