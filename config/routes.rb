# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             class_name: 'FormUser',
             controllers: {
               omniauth_callbacks: 'omniauth_callbacks',
               registrations: 'registrations'
             }

  resources :widgets do
    collection do
      get :vanillajs_demo
      get :bootstrap_demo
      get :react_demo
      get :svelte_demo
      get :svelte_widget
    end
  end

  resources :identities, only: %i[index show] do
    member do
      get :show_sites
    end
    scope module: "identities" do
      resources :sites, only: %i[show] do
        member do
          get :show_site
        end
      end
    end
  end

  authenticated :user do
    get "/", to: redirect("/identities")
  end

  root to: 'home#index'
end
