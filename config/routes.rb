Rails.application.routes.draw do
  root 'static_pages#dashboard'

  resources :sections, except: [:create, :destroy, :new] do
    resources :subnets, shallow: true do
      resources :addresses
    end
  end
end
