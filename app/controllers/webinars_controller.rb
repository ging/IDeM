class WebinarsController < ApplicationController

  before_filter :authenticate_user!
  

  #############
  # REST methods
  #############

  def index
    redirect_to home_path
  end

  def show
    @webinar = Webinar.find(params[:id])
  end

  def new
    @webinar = Webinar.new
  end

  def edit
    @webinar = Webinar.find(params[:id])
  end

  def create
    params[:webinar].permit!
    @webinar = Webinar.new(params[:webinar])
    # @webinar.publication_id = session[:current_publication_id]
    @webinar.author_id = current_user.id
    @webinar.save!
    respond_to do |format|
      format.all { redirect_to webinar_path(@webinar) }
    end
  end

  def update
    params[:webinar].permit! if params[:webinar]
    @webinar = Webinar.find(params[:id])
    @webinar.update_attributes!(params[:webinar])
    respond_to do |format|
      format.all { redirect_to webinar_path(@webinar) }
    end
  end

  def destroy
    @webinar = Webinar.find(params[:id])
    @webinar.destroy
    respond_to do |format|
      format.all { redirect_to user_path(current_user) }
    end
  end

end