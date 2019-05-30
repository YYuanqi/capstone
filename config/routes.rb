Rails.application.routes.draw do
  scope "/api", defaults: {format: :json} do
    resources :cities, excpet: [:new, :edit]
    end
  root "ui#index"
end
