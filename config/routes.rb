Wmail::Engine.routes.draw do
  root :to => "wmail_accounts#index"
  match "/", :to => "wmail_accounts#index"

  resources :wmail_accounts do
    collection do
      get :login
      post :authenticate
    end
  end

  resources :mailboxes, :only => [:index] do
    collection do
      get :mails
      get :messages
    end
    member do
      get :messages
    end
  end
end