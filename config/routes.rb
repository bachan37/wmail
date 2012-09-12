Wmail::Engine.routes.draw do
  root :to => "wmail_accounts#authenticate"
  #match "/", :to => "wmail_accounts#index"

  resources :wmail_accounts do
    collection do
      get :login
      get :authenticate
    end
  end

  resources :mailboxes, :only => [:index] do
    collection do
      get :mails
      get :messages
      get :fetch_mail
    end
    member do
      get :messages
    end
  end

  resources :mails
end