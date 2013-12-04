KnodaWeb::Application.routes.draw do
  root 'home#index'
  get 'about' => 'home#about'
  get 'privacy' => 'home#privacy'
  get 'terms' => 'home#terms'
  get 'robots.txt' => 'robots#robots'
  
  get 'predictions/:id/share' => 'predictions#showShared'

  get '/support', to: redirect('https://knoda.zendesk.com/hc/en-us')
end
