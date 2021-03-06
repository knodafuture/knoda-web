KnodaWeb::Application.routes.draw do
  root 'home#index'
  get 'start' => 'home#start'
  get 'thebuzz', to: redirect('/')
  get '1mc', to: redirect('/')
  get 'embedDemo' => 'home#embedDemo'
  get 'socialDemo' => 'home#socialDemo'
  get 'embed-login' => 'home#embed_login'
  get 'sitemap.xml.gz' => 'home#sitemap'

 devise_for :users, :controllers => {:sessions => 'sessions', :omniauth_callbacks => "omniauth_callbacks"}, :skip => [:sessions] do
    get '/'   => "home#index",       :as => :new_user_session
    post '/signin'  => 'sessions#create',    :as => :user_session
    get '/signout'  => 'sessions#destroy',   :as => :destroy_user_session
    get "/"   => "home#index",   :as => :new_user_registration

  resources :predictions do
    member do
      post 'close'
      get 'tally'
      get 'share'
      get 'share_dialog'
      get 'comments'
      post 'bs'
      post 'facebook_share'
      post 'twitter_share'
      get 'embed'
    end
  end
  resources :challenges
  get '/users/password/edit' => 'passwords#edit'
  put '/users/password' => 'passwords#update'
  resources :users do
    member do
      get 'avatar'
      get 'crop'
      post 'avatar_upload'
      get 'settings'
      get 'history'
      get 'social'
      post 'contest_agreement'
      get 'rivals'
    end
    collection do
      get 'autocomplete'
    end
  end
  resources :comments
  resources :activities
  resources :search
  resources :groups do
    member do
      get 'leaderboard'
      get 'settings'
      get 'invite'
      get 'avatar'
      get 'crop'
      post 'avatar_upload'
      get 'share'
      get 'predictions'
    end
    collection do
      get 'join'
    end
  end
  resources :invitations do
    collection do
      get 'accept'
    end
  end
  resources :memberships

  resources :twitter
  resources :facebook

  resources :social_accounts
  resources :friends do
    collection do
      get 'find'
      get 'find/:source' => 'friends#find'
    end
  end

  get 'about' => 'home#about'
  get 'privacy' => 'home#privacy'
  get 'terms' => 'home#terms'
  get 'robots.txt' => 'robots#robots'
  get 'predictions/:id/share' => 'predictions#showShared'
  get '/support', to: redirect('https://knoda.zendesk.com/hc/en-us')
  end

  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end

  resources :contests do
    collection do
      get 'admin'
    end
    member do
      get 'embed'
      get 'edit'
      get 'standings'
      get 'avatar'
      get 'crop'
      post 'avatar_upload'
    end
  end

  resources :contest_stages
  resources :followings

  resources :embed_locations
  resources :hashtags do
    collection do
      get 'autocomplete'
    end
  end
  namespace :admin do
    get '/' => "home#index"
    post '/test_data/prediction' => "test_data#create_prediction"
    post '/test_data/vote' => "test_data#create_votes"
    post '/test_data/comment' => "test_data#create_comments"
    post '/users/search' => "users#search"
    put '/users/:id' => "users#update"
    post '/push/confirmpush'=> "push#confirmpush"
    post '/push/sendpush'=> "push#sendpush"
    post '/predictions/search' => "predictions#search"
    delete '/predictions/:id' => "predictions#delete"
    delete '/comments/:id' => "comments#delete"
  end
end
