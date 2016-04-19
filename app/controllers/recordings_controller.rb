class RecordingsController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]

  #############
  # REST methods
  #############

  def index
    redirect_to home_path
  end

  def show
    @recording = Recording.find(params[:id])
    username = current_user ? current_user.id.to_s : "Guest"
    role = (current_user && @recording.author_id==current_user.id) ? "IDEM_owner" : "IDEM_viewer"
    @token = NuveInstance.createToken(@recording.room_id, username, role)
  end

  def new
    session[:current_publication_id] = params["publication"] unless params["publication"].blank?
    @recording = Recording.new
  end

  def edit
    @recording = Recording.find(params[:id])
  end

  def create
    params[:recording].permit!
    @recording = Recording.new(params[:recording])
    if !params[:recording][:publication_id]
      @recording.publication_id = session[:current_publication_id]
    end
    @recording.author_id = current_user.id
    options = {data: {user_id: current_user.id, publication_id: session[:current_publication_id], user_name: current_user.name}}
    room = NuveInstance.createRoom(params[:recording][:title], options)
    @recording.room_id = JSON.parse(room)["_id"]
    @recording.save!
    respond_to do |format|
      format.all { redirect_to recording_path(@recording) }
    end
  end

  def update
    params[:recording].permit! if params[:recording]
    @recording = Recording.find(params[:id])
    @recording.update_attributes!(params[:recording])
    respond_to do |format|
      format.all { redirect_to recording_path(@recording) }
    end
  end

  def destroy
    @recording = Recording.find(params[:id])
    @recording.destroy
    respond_to do |format|
      format.all { redirect_to user_path(current_user) }
    end
  end

end
