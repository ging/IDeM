class HomeController < ApplicationController

  def index
    @presentations = Presentation.all.public
    @webinars = Webinar.all
    @recordings = Recording.all
  end

end