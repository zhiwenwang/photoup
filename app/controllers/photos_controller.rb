class PhotosController < ApplicationController
  before_action :flickr_auth, only:[:create]


  def index
  end

  def show
  end

  def new
    @photo = Photo.new
  end

  def create
    photo_id = flickr.upload_photo(params[:photo].tempfile.path)
    photo_url = FlickRaw.url_o(flickr.photos.getInfo(:photo_id => photo_id))
    redirect_to photo_url
  end
private
    def flickr_auth
    FlickRaw.api_key='';
    FlickRaw.shared_secret='';
    flickr.access_token = ''
    flickr.access_secret = ''   
  end
end
