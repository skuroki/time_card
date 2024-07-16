Rails.application.routes.draw do
  root to: 'attendances#index'
  resources :rest_finishes, except: %i[index show new]
  resources :rests, except: %i[index show new]
  resources :clock_outs, except: %i[index show new]
  resources :attendances, except: %i[show new] do
    member do
      get :working_time
    end
    collection do
      get :report
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
