Rails.application.routes.draw do
  resources :sections, except: [:create, :destroy, :new] do
    resources :subnets, shallow: true do
      resources :addresses
    end
  end
end
