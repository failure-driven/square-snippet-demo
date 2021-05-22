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

  root to: 'home#index'
end
