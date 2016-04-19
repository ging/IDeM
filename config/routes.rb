Rails.application.routes.draw do
  root "home#index"

  #Users
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" }

  match '/users/:id/publications' => 'users#show_publications', via: [:get]
  match '/users/:id/presentations' => 'users#show_presentations', via: [:get]
  match '/users/:id/webinars' => 'users#show_webinars', via: [:get]
  match '/users/:id/followings' => 'users#show_followings', via: [:get]
  match '/users/:id/followers' => 'users#show_followers', via: [:get]
  match '/users/:id/network' => 'users#show_network', via: [:get]
  resources :users

  #Locale
  match '/change_locale', to: 'locales#change_locale', via: [:get]

  #Thumbnails
  match '/thumbnails' => 'presentations#presentation_thumbnails', via: [:get]

  #Documents
  match '/presentations/documents' => 'documents#create', :via => :post
  match '/presentations/:id/documents' => 'documents#create', :via => :post
  resources :documents
  resources :pictures

  #Presentations
  match 'presentations/last_slide' => 'presentations#last_slide', :via => :get
  match 'excursions/preview' => 'presentations#preview', :via => :get
  match 'presentations/:id/metadata' => 'presentations#metadata', :via => :get
  match 'presentations/:id/scormMetadata' => 'presentations#scormMetadata', :via => :get
  match '/excursions/:id/upload_attachment' => 'presentations#upload_attachment', :via => :post
  match '/presentations/:id/attachment' => 'presentations#show_attachment', :via => :get
  match '/presentations/:id.licode' => 'presentations#show', :defaults => { :format => "gateway", :gateway => 'licode' }, :via => :get
  match '/presentations/:id.embed' => 'presentations#show', :defaults => { :format => "full" }, :via => :get
  #Download JSON
  match '/excursions/tmpJson' => 'excursions#uploadTmpJSON', :via => :post
  match '/excursions/tmpJson' => 'excursions#downloadTmpJSON', :via => :get

  resources :presentations

  #Webinars
  resources :webinars
  #Recordings
  resources :recordings

  #PDF to Presentation
  # resources :pdfexes, :except => [:index], controller: 'pdfps'
  resources :pdfps, :except => [:index]

  #Wildcard route (This rule should be placed the last)
  match "*not_found", :to => 'application#page_not_found', via: [:get]
end
