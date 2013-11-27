KnodaWeb::Application.routes.draw do
  root 'home#index'
  get 'about' => 'home#about'
  get 'privacy' => 'home#privacy'
  get 'terms' => 'home#terms'

  get 'predictions/:id/share' => 'predictions#showShared'
end
