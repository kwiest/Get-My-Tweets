MyTweets::Application.routes.draw do
  match '/sign_in'  => 'sessions#create', via: 'post'
  match '/sign_out' => 'sessions#destroy', via: 'delete'

  root to: 'index#my_tweets', constraints: AuthenticationConstraint
  root to: 'index#index'
end
