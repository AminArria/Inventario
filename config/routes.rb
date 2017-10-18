Rails.application.routes.draw do
  root 'static_pages#dashboard'

  get 'sign_in', to: 'static_pages#sign_in', as: 'sign_in'
  post 'authenticate', to: 'static_pages#authenticate', as: 'authenticate'
  get 'sign_out', to: 'static_pages#sign_out', as: 'sign_out'

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

  resources :storage_boxes, except: [:create, :destroy, :new, :edit] do
    resources :aggregates, shallow: true do
      resources :volumes, shallow: true
    end
  end
end
