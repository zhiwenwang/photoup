require 'google_drive'
class GoogleUploadController < ApplicationController
layout 'google_upload'

before_filter :google_drive_login, :only => [:list_google_docs, :new, :create]
skip_before_filter :verify_authenticity_token, :only => [:create]

 GOOGLE_CLIENT_ID = ""
 GOOGLE_CLIENT_SECRET = ""
 GOOGLE_CLIENT_REDIRECT_URI = "http://localhost:3000/oauth2callback"
  # you better put constant like above in environments file, I have put it just for simplicity
   
  def list_google_docs
    google_session = GoogleDrive.login_with_oauth(session[:google_token])
    @google_docs = Array.new
    google_session.files.each do |file|
    @google_docs.push(file.title)
    end   
  end

  def show

  end

  def new
  end

  def user_info

  end

  def create
    params[:fileselect].each {
      |file|
      file_path = file.path
      file_name = file.original_filename
      google_session = GoogleDrive.login_with_oauth(session[:google_token])
      google_session.upload_from_file(file_path, file_name, :convert => false)
    }
    redirect_to google_upload_index_path
  end

def download_google_docs
    file_name = params[:doc_upload]
    file_path = Rails.root.join('tmp',"doc_#{file_name}")
    google_session = GoogleDrive.login_with_oauth(session[:google_token])
    file = google_session.file_by_title(file_name)
    file.download_to_file(file_path)
    redirect_to list_google_doc_path
  end

  def set_google_drive_token
    oauth_client = create_google_client
    auth_token = oauth_client.auth_code.get_token(params[:code], 
                 :redirect_uri => GOOGLE_CLIENT_REDIRECT_URI)
    session[:google_token] = auth_token.token if auth_token
    redirect_to new_google_upload_path
  end

  def google_drive_login
    unless session[:google_token].present?
      auth_url = set_google_authorize_url
      redirect_to auth_url
    end

  end
  private
  def set_google_authorize_url
    
      client = create_google_client
      client.auth_code.authorize_url(
        :redirect_uri => GOOGLE_CLIENT_REDIRECT_URI,
        :access_type => "offline",
        :scope =>
          "https://docs.google.com/feeds/ " +
          "https://docs.googleusercontent.com/ " +
          "https://spreadsheets.google.com/feeds/")
    end
    def create_google_client

      OAuth2::Client.new(
        GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET,
        :site => "https://accounts.google.com",
        :token_url => "/o/oauth2/token",
        :authorize_url => "/o/oauth2/auth")

    end
    def login_with_oauth(client_or_access_token, proxy = nil)
      return Session.new(client_or_access_token, proxy)

    end
end