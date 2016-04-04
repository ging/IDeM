class HomeController < ApplicationController

  def index
  	@presentations = Presentation.all
  	@webinars = Presentation.all
  end

end