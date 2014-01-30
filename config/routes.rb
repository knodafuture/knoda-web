KnodaWeb::Application.routes.draw do
  root 'home#index'
  get 'start' => 'home#start'
  get 'thebuzz' => 'home#start'
  get '1mc' => 'home#start'
  
 devise_for :users, :controllers => {:sessions => 'sessions'}, :skip => [:sessions] do
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
    end
  end
  resources :challenges
  get '/users/password/edit' => 'passwords#edit'
  put '/users/password' => 'passwords#update'
  resources :users do
    member do
      get 'avatar'
      get 'default_avatar'
      get 'crop'
      post 'avatar_upload'
    end
  end
  resources :comments
  resources :badges
  resources :history
  resources :activities
  resources :search
  
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
end
