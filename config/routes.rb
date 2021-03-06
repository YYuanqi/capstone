Rails.application.routes.draw do
  get 'authn/whoami', defaults: {format: :json}
  get 'authn/checkme'
  mount_devise_token_auth_for 'User', at: 'auth'
  scope "/api", defaults: {format: :json} do
    resources :cities, except: [:new, :edit]
    resources :states, except: [:new, :edit]
    resources :images, except: [:new, :edit] do
      post 'thing_images' => 'thing_images#create'
      get 'thing_images' => 'thing_images#image_things'
      get 'linkable_things' => 'thing_images#linkable_things'
    end
    resources :things, except: [:new, :edit] do
      resources :thing_images, only: [:index, :create, :update, :destroy]
    end
    get 'images/:id/content', as: :image_content, controller: :images, action: :content, defaults: {format: :jpg}
  end
  get '/ui' => 'ui#index'
  get '/ui#' => 'ui#index'
  root "ui#index"
end
