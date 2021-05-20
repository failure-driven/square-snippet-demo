Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :widgets do
    collection do
      get :vanillajs_demo
      get :bootstrap_demo
      get :react_demo
    end
  end
end
