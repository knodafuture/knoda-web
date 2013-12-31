KnodaWeb::Application.routes.draw do
  root 'home#new'
  resources :predictions
  
  get 'about' => 'home#about'
  get 'privacy' => 'home#privacy'
  get 'terms' => 'home#terms'
  get 'robots.txt' => 'robots#robots'
  
  get 'predictions/:id/share' => 'predictions#showShared'

  get '/support', to: redirect('https://knoda.zendesk.com/hc/en-us')

  get '/account' => 'users#account'
  get '/users/password/edit' => 'users#cp'

  get 'feed' => 'predictions#feed'

  devise_for :users, 
    :path => "auth", 
    :path_names => 
      { :sign_in => 'login', 
        :sign_out => 'logout', 
        :confirmation => 'verification', 
        :unlock => 'unblock', 
        :registration => 'register', 
        :sign_up => 'cmon_let_me_in' 
      }
  devise_scope :user do
    get "register"  => "devise/registrations#new"
    get "login"  => "devise/sessions#new"
  end

  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end


end
