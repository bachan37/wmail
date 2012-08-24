Rails.application.routes.draw do

  mount Wmail::Engine => "/wmail"
  root :to => 'users#index'
  resources :users, :only => [:index, :new, :create] do
    collection do
      post :signin
      get :home
      get :signout
    end
  end

end
