class HomeController < ApplicationController

  def index
    @presentations = Presentation.all
    @webinars = Webinar.all
  end

end