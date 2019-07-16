Rails.application.routes.draw do
  get 'authn/whoami'
  get 'authn/checkme'
  mount_devise_token_auth_for 'User', at: 'auth'
  scope "/api", defaults: {format: :json} do
    resources :cities, except: [:new, :edit]
    resources :states, except: [:new, :edit]
    end
  root "ui#index"
end
