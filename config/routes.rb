Rails.application.routes.draw do
  root "home#index"

  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users
  
  match '/account', to: 'users#show', via: [:get]
 
  match '/change_locale', to: 'locales#change_locale', via: [:get]
  #Thumbnails
  match '/thumbnails' => 'presentations#presentation_thumbnails', via: [:get]

  match 'presentations/last_slide' => 'presentations#last_slide', :via => :get
  match 'excursions/preview' => 'excursions#preview', :via => :get
  match 'excursions/:id/metadata' => 'excursions#metadata', :via => :get
  match 'excursions/:id/scormMetadata' => 'excursions#scormMetadata', :via => :get
  match '/excursions/:id/upload_attachment' => 'excursions#upload_attachment', :via => :post
  match '/excursions/:id/attachment' => 'excursions#show_attachment', :via => :get
  match '/excursions/:id.mashme' => 'excursions#show', :defaults => { :format => "gateway", :gateway => 'mashme' }, :via => :get
  match '/excursions/:id.embed' => 'excursions#show', :defaults => { :format => "full" }, :via => :get

  resources :presentations


  #Download JSON
  match '/excursions/tmpJson' => 'excursions#uploadTmpJSON', :via => :post
  match '/excursions/tmpJson' => 'excursions#downloadTmpJSON', :via => :get

  resources :excursions

  #Wildcard route (This rule should be placed the last)
  match "*not_found", :to => 'application#page_not_found', via: [:get]
end
