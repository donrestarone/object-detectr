Rails.application.routes.draw do
  resources :images, only: [:create, :new, :index]

  root to: "images#new"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
