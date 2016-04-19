class HomeController < ApplicationController

  def index
    @presentations = Presentation.all
    @webinars = Webinar.all
    @recordings = Recording.all
  end

end