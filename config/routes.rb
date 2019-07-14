Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  scope "/api", defaults: {format: :json} do
    resources :cities, excpet: [:new, :edit]
    resources :states, excpet: [:new, :edit]
    end
  root "ui#index"
end
