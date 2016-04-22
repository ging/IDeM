# Set up Recommender System settings
# Store some variables in configuration to speed things up
# Config accesible in EuropeanaRS::Application::config

Rails.application.configure do
  
  #EuropeanaRS fixed settings
  config.settings = {}
  config.settings = config.APP_CONFIG["settings"].parse_for_rs unless config.APP_CONFIG["settings"].blank?
  config.settings = {:max_text_length => 50, :max_user_los => 1, :max_user_pastlos => 4, :idem_database => {:max_preselection_size => 500}, :loop_database => {:preselection_size => 500}}.recursive_merge(config.settings)

  #Default settings to use in IDeM
  config.default_settings = {}
  config.default_settings = config.APP_CONFIG["default_settings"].parse_for_rs unless config.APP_CONFIG["default_settings"].blank?
  config.default_settings = {:database => "IDeM", :preselection_filter_resource_type => "true", :preselection_filter_languages => "true", :idem_database => {:preselection_size => 500}, :loop_database => {:preselection_size => 500, :query => {}}}.recursive_merge(config.default_settings)

  #Default weights
  weights = {}
  weights[:default_rs] = RecommenderSystem.defaultRSWeights
  weights[:default_los] = RecommenderSystem.defaultLoSWeights
  weights[:default_us] = RecommenderSystem.defaultUSWeights
  weights[:popularity] = RecommenderSystem.defaultPopularityWeights

  if config.APP_CONFIG["weights"]
    weights[:default_rs] = weights[:default_rs].recursive_merge(config.APP_CONFIG["weights"]["default_rs"].parse_for_rs) if config.APP_CONFIG["weights"]["default_rs"]
    weights[:default_los] = weights[:default_los].recursive_merge(config.APP_CONFIG["weights"]["default_los"].parse_for_rs) if config.APP_CONFIG["weights"]["default_los"]
    weights[:default_us] = weights[:default_us].recursive_merge(config.APP_CONFIG["weights"]["default_us"].parse_for_rs) if config.APP_CONFIG["weights"]["default_us"]
    weights[:popularity] = weights[:popularity].recursive_merge(config.APP_CONFIG["weights"]["popularity"].parse_for_rs) if config.APP_CONFIG["weights"]["popularity"]
  end

  config.weights = weights


  #Default filters
  filters = {}
  filters[:default_rs] = RecommenderSystem.defaultRSFilters
  filters[:default_los] = RecommenderSystem.defaultLoSFilters
  filters[:default_us] = RecommenderSystem.defaultUSFilters

  if config.APP_CONFIG["filters"]
    filters[:default_rs] = filters[:default_rs].recursive_merge(config.APP_CONFIG["filters"]["default_rs"].parse_for_rs)if config.APP_CONFIG["filters"]["default_rs"]
    filters[:default_los] = filters[:default_los].recursive_merge(config.APP_CONFIG["filters"]["default_los"].parse_for_rs)if config.APP_CONFIG["filters"]["default_los"]
    filters[:default_us] = filters[:default_us].recursive_merge(config.APP_CONFIG["filters"]["default_us"].parse_for_rs)if config.APP_CONFIG["filters"]["default_us"]
  end

  config.filters = filters

  
  #Search Engine
  # config.max_matches = ThinkingSphinx::Configuration.instance.settings["max_matches"] || 10000 #Sphinx not available yet
  config.max_matches = 10000
  config.settings[:idem_database][:max_preselection_size] = [config.max_matches,config.settings[:idem_database][:max_preselection_size]].min

  #RS: internal settings
  config.max_user_los = (config.settings[:max_user_los].is_a?(Numeric) ? config.settings[:max_user_los] : 1)
  config.max_user_pastlos = (config.settings[:max_user_pastlos].is_a?(Numeric) ? config.settings[:max_user_pastlos] : 4)

  #Settings for speed up TF-IDF calculations
  config.max_text_length = (config.settings[:max_text_length].is_a?(Numeric) ? config.settings[:max_text_length] : 50)
  # config.repository_total_entries = [Lo.count,1].max #Not used

  config.stoptags = File.read("config/stoptags.yml").split(",").map{|s| s.gsub("\n","").gsub("\"","") } rescue []
end


