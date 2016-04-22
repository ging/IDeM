# encoding: utf-8

###############
# Class for using the Loop Search API
###############

class Loop

  def self.search(queryParams={})
    require 'rest-client'
    (JSON.parse(RestClient::Request.execute(:method => :get, :url => buildQuery(queryParams), :timeout => 5, :open_timeout => 5))) rescue nil #nil => error connecting to Loop
  end

  def self.buildQuery(params={})
    params.delete_if{|k,v| v.blank?} #Delete empty params

    # #Convert arrays with one element into strings (prevent errors)
    # params.each{ |k,v|
    #   params[k] = v.first if v.is_a? Array and v.length===1
    # }

    keyword = ""
    keyword = params[:keyword] if params[:keyword].is_a? String

    #Query example using the Loop Search API
    #https://api.frontiersin.org/v2/publications/search.bykeyword(keyword='neocortex')?key=oauth2_primary_subscription_key
    query = "https://api.frontiersin.org/v2/publications/search.bykeyword(keyword='" + keyword + "')?key="+IDeM::Application::config.APP_CONFIG["loop"]["oauth2_primary_subscription_key"]
    
    query
  end

  def self.createVirtualLoProfileFromItem(loopItem,options={})
    lo_profile = {}
    lo_profile[:repository] = "Loop"
    lo_profile[:id_repository] = loopItem["id"]
    lo_profile[:resource_type] = "Publication"
    lo_profile[:title] = loopItem["title"]
    lo_profile[:description] = loopItem["abstract"]
    lo_profile[:quality] = 0
    lo_profile[:popularity] = 0
    lo_profile[:url] = loopItem["loopUrl"]
    lo_profile[:external] = true unless options[:external]
    lo_profile
  end

end