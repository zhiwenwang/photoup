Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  get 'users/index'
  # root 'users#index'
  root 'google_upload#index'
  resources :photos
  resources :google_upload
  get 'oauth2callback' => 'google_upload#set_google_drive_token' 
  # post 'upload_google_doc'  => 'google_upload#upload_google_docs', :as => :upload_google_doc
  get 'list_google_doc'  => 'google_upload#list_google_docs', :as => :list_google_doc #for listing the 
  get 'download_google_doc'  => 'google_upload#download_google_docs', :as => :download_google_doc #download
  # get 'upload_google'  => 'google_upload#upload_google', :as => :upload_google
end
