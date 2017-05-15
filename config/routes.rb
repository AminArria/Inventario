Rails.application.routes.draw do
  resources :sections, except: [:create, :destroy, :new]
end
