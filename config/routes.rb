GetMyTweets::Application.routes.draw do
  match '/sign_in'  => 'sessions#create', via: 'post'
  match '/sign_out' => 'sessions#destroy', via: 'delete'

  resources :users, only: %w(new show create destroy)
  resources :api_keys, only: %w(create destroy)
  resources :authorizations, only: %w(new show create destroy)

  match '/oauth/callback/:id' => 'authorizations#update'

  match '/my_tweets/:username' => 'tweets#index'

  root to: 'users#show', constraints: AuthenticationConstraint
  root to: 'index#index'
end
