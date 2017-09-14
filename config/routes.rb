Rails.application.routes.draw do
  root 'static_pages#dashboard'

  scope :reports, as: :reports do
    get 'general', to: "reports#general", as: 'general'
    get 'new', to: "reports#new", as: 'new'
    get 'create', to: "reports#create", as: 'create'
  end

  resources :sections, except: [:create, :destroy, :new] do
    resources :subnets, shallow: true do
      resources :addresses
    end
  end

  resources :data_centers, except: [:create, :destroy, :new] do
    resources :clusters, shallow: true do
      resources :hosts, shallow: true
    end
  end
end
