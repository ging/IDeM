class HomeController < ApplicationController

  def index
    @presentations = RecommenderSystem.suggestions({:n => 20, :user_profile => current_user_profile, :settings => {:database => "IDeM", :preselection_filter_by_resource_types => ["Presentation"]}})
    @webinars = RecommenderSystem.suggestions({:n => 20, :user_profile => current_user_profile, :settings => {:database => "IDeM", :preselection_filter_by_resource_types => ["Webinar"]}})
    @recordings = RecommenderSystem.suggestions({:n => 20, :user_profile => current_user_profile, :settings => {:database => "IDeM", :preselection_filter_by_resource_types => ["Recording"]}})
    @recommended_publications = RecommenderSystem.suggestions({:n => 20, :user_profile => current_user_profile, :settings => {:database => "Loop", :preselection_filter_by_resource_types => ["Publication"]}})
  end

end