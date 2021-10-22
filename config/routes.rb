Rails.application.routes.draw do
  root to: 'attendances#index'
  resources :rest_finishes, except: [:new]
  resources :rests, except: [:new]
  resources :clock_outs, except: [:new]
  resources :attendances, except: [:show, :new] do
    collection do
      get :report
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
