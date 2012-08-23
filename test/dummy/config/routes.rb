Rails.application.routes.draw do

  mount Wmail::Engine => "/wmail"

  resources :users, :only => [:index, :new, :create, :destroy] do
    collection do
      post :signin
      get :home
    end
  end

end
