class WebinarsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]


  #############
  # REST methods
  #############

  def index
    redirect_to home_path
  end

  def show
    @webinar = Webinar.find(params[:id])
    username = current_user ? current_user.id.to_s : "Guest"
    role = (current_user && @webinar.author_id==current_user.id) ? "IDEM_owner" : "IDEM_viewer"
    @token = NuveInstance.createToken(@webinar.room_id, username, role)
    idem_resource_suggestions = RecommenderSystem.suggestions({:n => 4, :lo_profile => @webinar.profile, :settings => {:database => "IDeM", :preselection_filter_by_resource_types => ["Presentation", "Webinar", "Recording"]}})
    loop_publication_suggestions = RecommenderSystem.suggestions({:n => 4, :lo_profile => @webinar.publication.profile, :settings => {:database => "Loop", :preselection_filter_by_resource_types => ["Publication"]}})
    @recommended_resources = idem_resource_suggestions.concat(loop_publication_suggestions).shuffle
  end

  def new
    session[:current_publication_id] = params["publication"] unless params["publication"].blank?
    @webinar = Webinar.new
  end

  def edit
    @webinar = Webinar.find(params[:id])
  end

  def create
    params[:webinar].permit!
    @webinar = Webinar.new(params[:webinar])
    if !params[:webinar][:publication_id]
      @webinar.publication_id = session[:current_publication_id]
    end
    @webinar.author_id = current_user.id
    options = {data: {user_id: current_user.id, publication_id: @webinar.publication_id, user_name: current_user.name}}
    room = NuveInstance.createRoom(params[:webinar][:title], options.to_json)
    @webinar.room_id = JSON.parse(room)["_id"]
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
    NuveInstance.deleteRoom(@webinar.room_id)
    @webinar.destroy
    respond_to do |format|
      format.all { redirect_to user_path(current_user) }
    end
  end

end
