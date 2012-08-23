Rails.application.routes.draw do

  mount Wmail::Engine => "/wmail"

  resources :users, :only => [:index, :new, :create] do
    collection do
      post :signin
      get :home
      get :signout
    end
  end

end
