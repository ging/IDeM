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
  resources :documents
  resources :pictures

  #Presentations
  match '/presentations/:id/metadata' => 'presentations#metadata', :via => :get
  match '/presentations/:id/scormMetadata' => 'presentations#scormMetadata', :via => :get
  match '/presentations/last_slide' => 'presentations#last_slide', :via => :get
  match '/presentations/preview' => 'presentations#preview', :via => :get
  match '/presentations/tmpJson' => 'presentations#uploadTmpJSON', :via => :post
  match '/presentations/tmpJson' => 'presentations#downloadTmpJSON', :via => :get

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
