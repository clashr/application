Rails.application.routes.draw do
  # submissions as a nested resource within contests
  resources :contests do
    resources :submissions
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
