require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

#Configuration accesible through the IDeM::Application::config var.
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
    config.full_domain = "http://" + config.domain

    config.name = (config.APP_CONFIG["name"] || "IDeM")
    
    # I18n (http://guides.rubyonrails.org/i18n.html)
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.available_locales = [config.i18n.default_locale, :es].uniq
    # I18n fallbacks: rails will fallback to config.i18n.default_locale translation
    config.i18n.fallbacks = true

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    #Load ViSH Editor plugin
    config.before_configuration do
      $:.unshift File.expand_path("#{__FILE__}/../../lib/plugins/vish_editor/lib")
      require 'vish_editor'
    end

    #Tags settings

    #Tags
    config.tagsSettings = (config.APP_CONFIG['tagsSettings'] || {})
    default_tags = {
        "minLength" => 2,
        "maxLength" => 20,
        "maxTags" => 10,
        "tagSeparators" => [',',';'],
        "triggerKeys" => ['enter', 'comma', 'tab', 'space']
    }
    config.tagsSettings = default_tags.merge(config.tagsSettings)

    #External services settings
    config.uservoice = (!config.APP_CONFIG['uservoice'].nil? and !config.APP_CONFIG['uservoice']["scriptURL"].nil?)
    config.ganalytics = (!config.APP_CONFIG['ganalytics'].nil? and !config.APP_CONFIG['ganalytics']["trackingID"].nil?)
    config.gwebmastertools = (!config.APP_CONFIG['gwebmastertools'].nil? and !config.APP_CONFIG['gwebmastertools']["site-verification"].nil?)
    config.facebook = (!config.APP_CONFIG['facebook'].nil? and !config.APP_CONFIG['facebook']["appID"].nil? and !config.APP_CONFIG['facebook']["accountID"].nil?)
    config.twitter = (!config.APP_CONFIG['twitter'].nil? and config.APP_CONFIG['twitter']["enable"]===true)
    config.gplus = (!config.APP_CONFIG['gplus'].nil? and config.APP_CONFIG['gplus']["enable"]===true)

    config.after_initialize do
      #Agnostic random
      if ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
        config.agnostic_random = "RANDOM()"
      else
        #MySQL
        config.agnostic_random = "RAND()"
      end
    end

    ActsAsTaggableOn.strict_case_match = true

    config.subtype_classes_mime_types = {
      :picture => [:jpeg, :gif, :png, :bmp, :xcf],
      :zipfile=> [:zip],
      :officedoc=> [:odt, :odp, :ods, :doc, :ppt, :xls, :rtf, :pdf]
    }

    #Require core extensions
    Dir[File.join(Rails.root, "lib", "core_ext", "*.rb")].each {|l| require l }
    Dir[File.join(Rails.root, "lib", "acts_as_taggable_on", "*.rb")].each {|l| require l }
  end
end
