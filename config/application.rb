require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module IDeM
  class Application < Rails::Application

    #Automatically connect to the database when a rails console is started
    console do
      ActiveRecord::Base.connection
    end

    #Load IDeM configuration
    #Accesible here: IDeM::Application::config.APP_CONFIG
    config.APP_CONFIG = YAML.load_file("config/application_config.yml")[Rails.env]
    config.domain = (config.APP_CONFIG["domain"] || "localhost:3000")

    # I18n (http://guides.rubyonrails.org/i18n.html)
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.available_locales = [config.i18n.default_locale, :es].uniq
    # I18n fallbacks: rails will fallback to config.i18n.default_locale translation
    config.i18n.fallbacks = true

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    #Require core extensions
    Dir[File.join(Rails.root, "lib", "core_ext", "*.rb")].each {|l| require l }
  end
end
