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
        :scope => "openid profile_read",
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
        fullName = user_data["firstName"]
        fullName += (" " + user_data["lastName"]) unless user_data["lastName"].blank?
        info = {
          'name' => fullName,
          "loop_profile_url" => user_data["profileUrl"],
          "loop_id" => user_data["id"],
          "country" => user_data["country"]
        }

        case info["country"]
        when "Spain"
          info["language"] = "es"
        else
          info["language"] = I18n.locale.to_s
        end

        info
      end

      def user_data
        @user_data ||= access_token.get('me?key=' + IDeM::Application::config.APP_CONFIG["loop"]["oauth2_primary_subscription_key"]).parsed
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