Rails.application.routes.draw do
  resources :subnets
  resources :sections, except: [:create, :destroy, :new]
end
