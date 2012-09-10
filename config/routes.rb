MyTweets::Application.routes.draw do
  match '/sign_in'  => 'sessions#create', via: 'post'
  match '/sign_out' => 'sessions#destroy', via: 'delete'

  resources :users, only: %w(new show create destroy)

  root to: 'users#show', constraints: AuthenticationConstraint
  root to: 'index#index'
end
