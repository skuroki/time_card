Rails.application.routes.draw do
  resources :rest_finishes
  resources :rests
  resources :clock_outs
  resources :attendances
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
