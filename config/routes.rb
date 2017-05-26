Rails.application.routes.draw do
  root 'static_pages#dashboard'

  scope :reports, as: :reports do
    get 'general', to: "reports#general", as: 'general'
  end
  
  resources :sections, except: [:create, :destroy, :new] do
    resources :subnets, shallow: true do
      resources :addresses
    end
  end
end
