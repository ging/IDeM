# encoding: utf-8

###############
# Class for using the Loop Search API
###############

class Loop

  def self.search(queryParams={})
    require 'rest-client'
    (JSON.parse(RestClient::Request.execute(:method => :get, :url => buildQuery(queryParams), :timeout => 4, :open_timeout => 4))) rescue nil #nil => error connecting to Loop
  end

  def self.buildQuery(params={})
    params.delete_if{|k,v| v.blank?} #Delete empty params

    keyword = params[:keyword]
    keyword = keyword.join(" ") if keyword.is_a? Array
    keyword = keyword.strip.gsub(/([\s]+)/,"%20") if keyword.is_a? String
    keyword = "" unless keyword.is_a? String

    #Query example using the Loop Search API
    #https://api.frontiersin.org/v2/publications/search.bykeyword(keyword='learning%20objects')?key=oauth2_primary_subscription_key
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
    lo_profile[:keywords] = loopItem["keywords"]
    lo_profile[:quality] = 0
    lo_profile[:popularity] = 0
    lo_profile[:url] = loopItem["loopUrl"]
    lo_profile[:external] = options[:external] || true 
    lo_profile[:authors] = loopItem["authors"].map{|a| a["fullName"]}.flatten.uniq.join(",")
    lo_profile
  end

end