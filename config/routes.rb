Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'front_end/index'
    end
  end
  namespace :api do
    namespace :v1 do
      resources :stored_products
    end
  end
  mount ShopifyApp::Engine, at: '/'

  root to: 'api/v1/home#index'
  namespace :api do
    namespace :v1 do
      get 'home/index'
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
