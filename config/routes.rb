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

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development? || Rails.env.test?

  resources :identities, only: %i[index show] do
    member do
      get :show_sites
      post :toggle_feature
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
          get :test_demo
        end
      end
    end
  end
  get "/identities/:identity_id/sites/:id/portal/*all" => "identities/sites#portal"

  resources :sites do
    scope module: "sites" do
      resources :stories do
        resources :contents
      end
    end
  end

  resource :widget_auth, only: :new

  authenticated :user do
    get "/", to: redirect("/identities")
    resources :accounts, only: %i[index show edit update]
    get "/admin", to: "home#admin"
    post "/admin_generator", to: "home#admin_generator"
  end

  get "/terms-of-service", to: "home#terms"
  get "/privacy-policy", to: "home#privacy"

  root to: "home#index"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :sites do
        get "/visit_count", to: "sites#visit_count"
        patch "/visit_count", to: "sites#update_visit_count"
        resources :stories, only: %i[index show create]
      end
    end
  end
end
