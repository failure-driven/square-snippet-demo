Rails.application.routes.draw do
  devise_for :users,
             class_name: "FormUser",
             controllers: {
               omniauth_callbacks: "omniauth_callbacks",
               registrations: "registrations",
             }

  constraints CanAccessFlipperUI do
    mount Flipper::UI.app(Flipper) => "/flipper"
  end

  resources :identities, only: %i[index show] do
    member do
      get :show_sites
    end
    scope module: "identities" do
      resources :sites, only: %i[show update] do
        member do
          get :show_site
          post :add_widget
          post :remove_widget
          get :widget
          get :configure_site_config
          get :site_config
          get :stats
          get :portal
        end
      end
    end
  end
  get "/identities/:identity_id/sites/:id/portal/*all" => "identities/sites#portal"

  resources :users, only: [] do
    scope module: "users" do
      resources :stories, only: %i[index new]
    end
  end

  authenticated :user do
    get "/", to: redirect("/identities")
  end

  get "/terms-of-service", to: "home#terms"
  get "/privacy-policy", to: "home#privacy"

  root to: "home#index"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :sites do
        get "/visit_count", to: "sites#visit_count"
        patch "/visit_count", to: "sites#update_visit_count"
      end
    end
  end
end
