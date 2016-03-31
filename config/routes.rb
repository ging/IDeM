Rails.application.routes.draw do
  root "home#index"

  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :users
  resources :presentations
  
  match '/account', to: 'users#show', via: [:get]
 
  match '/change_locale', to: 'locales#change_locale', via: [:get]

  #Wildcard route (This rule should be placed the last)
  match "*not_found", :to => 'application#page_not_found', via: [:get]
end
