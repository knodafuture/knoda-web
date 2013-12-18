KnodaWeb::Application.routes.draw do
  root 'home#index'
  get 'about' => 'home#about'
  get 'privacy' => 'home#privacy'
  get 'terms' => 'home#terms'
  get 'robots.txt' => 'robots#robots'
  
  get 'predictions/:id/share' => 'predictions#showShared'

  get '/support', to: redirect('https://knoda.zendesk.com/hc/en-us')

  devise_for :users, skip: :registrations
  devise_scope :user do
    namespace :api do
      resource :session,      :only => [:create, :destroy] do
        member do
          get 'authentication_failure'
        end
      end
      resource :registration, :only => [:create]
    end

    resource :registration,
      only: [:new, :create, :edit, :update],
      path: 'users',
      path_names: { new: 'sign_up' },
      controller: 'devise/registrations',
      as: :user_registration do
        get :cancel
      end
  end
end
