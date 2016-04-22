class HomeController < ApplicationController

  def index
    @presentations = RecommenderSystem.suggestions({:n => 8, :user_profile => current_user_profile, :settings => {:database => "IDeM", :preselection_filter_by_resource_types => ["Presentation"]}})
    @webinars = Webinar.all
    @recordings = Recording.all
    #@recommended_publications = RecommenderSystem.suggestions({:n => 8, :user_profile => current_user_profile, :settings => {:database => "Loop", :preselection_filter_by_resource_types => ["Publication"]}})
  end

end