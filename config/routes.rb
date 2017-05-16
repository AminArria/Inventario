Rails.application.routes.draw do
  resources :sections, except: [:create, :destroy, :new] do
    resources :subnets, shallow: true
  end
end
