Wmail::Engine.routes.draw do
  root :to => "wmail_accounts#index"
  match "/", :to => "wmail_accounts#index"
end
