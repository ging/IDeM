Rails.application.routes.draw do
  root "home#index"

  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" }

  match '/users/:id/publications' => 'users#show_publications', via: [:get]
  match '/users/:id/presentations' => 'users#show_presentations', via: [:get]
  match '/users/:id/webinars' => 'users#show_webinars', via: [:get]
  resources :users
  
  match '/account', to: 'users#show', via: [:get]
 
  match '/change_locale', to: 'locales#change_locale', via: [:get]
  #Thumbnails
  match '/thumbnails' => 'presentations#presentation_thumbnails', via: [:get]

  match 'presentations/last_slide' => 'presentations#last_slide', :via => :get
  match 'excursions/preview' => 'presentations#preview', :via => :get
  match 'excursions/:id/metadata' => 'presentations#metadata', :via => :get
  match 'excursions/:id/scormMetadata' => 'presentations#scormMetadata', :via => :get
  match '/excursions/:id/upload_attachment' => 'presentations#upload_attachment', :via => :post
  match '/excursions/:id/attachment' => 'presentations#show_attachment', :via => :get
  match '/excursions/:id.mashme' => 'presentations#show', :defaults => { :format => "gateway", :gateway => 'mashme' }, :via => :get
  match '/excursions/:id.embed' => 'presentations#show', :defaults => { :format => "full" }, :via => :get

  resources :presentations

  #PDF to Presentation
  # resources :pdfexes, :except => [:index], controller: 'pdfps'
  resources :pdfps, :except => [:index]

  #Download JSON
  match '/excursions/tmpJson' => 'excursions#uploadTmpJSON', :via => :post
  match '/excursions/tmpJson' => 'excursions#downloadTmpJSON', :via => :get

  resources :excursions

  #Wildcard route (This rule should be placed the last)
  match "*not_found", :to => 'application#page_not_found', via: [:get]
end
