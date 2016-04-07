# Set up IDeM general settings
# Config accesible in IDeM::Application::config

require "#{Rails.root}/lib/nuve.rb"

Rails.application.configure do
  config.demo_user_available = true

  #initialize nuve service
  if IDeM::Application::config.APP_CONFIG["licode"]
  	::Nuve = Nuve.new(IDeM::Application::config.APP_CONFIG["licode"]["service_id"], IDeM::Application::config.APP_CONFIG["licode"]["service_key"], IDeM::Application::config.APP_CONFIG["licode"]["auth_url"])
	end


end