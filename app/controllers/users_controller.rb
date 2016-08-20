class UsersController < ApplicationController
  before_action :authenticate_user!
  require 'flickraw'
  before_action :set_photo, only: [:show]
  
    def index
    FlickRaw.api_key='';
    FlickRaw.shared_secret='';
    flickr.access_token = ''
    flickr.access_secret = '' 
    end

    def show
    end
    def new
      @photo = Photo.new
    end

    def create
      photo_id = flickr.upload_photo params[:photo].tempfile.path, :title => "Title", :description => "Description"
      photo_url = FlickRaw.url_o(flickr.photos.getInfo(photo_id: photo_id))
    @photo = Photo.new(photo_id: photo_id, photo_url: photo_url)
      respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Photo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @photo }
      else
        format.html { render action: 'new' }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
      end
    end
  private
    def set_photo
    @photo = Photo.find(params[:id])
    end
    def set_flickr
    FlickRaw.api_key='';
    FlickRaw.shared_secret='';
    Flickr.access_token = ''
    Flickr.access_secret = ''   
  end
end
