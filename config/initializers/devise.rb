Devise.setup do |config|
  config.navigational_formats = [:json]
  config.secret_key = ENV['DEVISE_SECRET_KEY']
end
