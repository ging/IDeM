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
    success = @recording.save!
    respond_to do |format|
      format.all {
        render :json => {:success => success, :recording => @recording}, :status => 200
      }
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

  def process_video
    @recording = Recording.find(params[:id])
    @recording.processing = true
    success = @recording.save
    #Execute bash script
    system "ffmpeg -i public/webinar_recordings/" + @recording.recording_id + ".mkv -c:v libx264 -profile:v baseline -level 3.1 -preset veryfast -r 24 -crf 21 -c:a libfaac -b:a 32K public/webinar_recordings/" + @recording.recording_id + ".mp4 -y &"
    respond_to do |format|
      format.all {
        render :json => {:success => success, :recording => @recording}, :status => 200
      }
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
