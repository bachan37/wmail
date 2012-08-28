Wmail::Engine.routes.draw do
  root :to => "wmail_accounts#index"
  match "/", :to => "wmail_accounts#index"

  resources :wmail_accounts do
    collection do
      get :login
      post :authenticate
    end
  end
end