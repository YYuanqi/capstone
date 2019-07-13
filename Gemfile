source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'mongoid', '~>7.0'
gem 'rack-cors', '~>1.0.3', :require => 'rack/cors'
gem 'pry-rails'
gem 'jbuilder', '~>2.9'

gem 'sass-rails', '~>5.0'
gem 'uglifier', '~>4.1'
gem 'coffee-rails', '~>4.1', '>=4.1.0'
gem 'jquery-rails', '~>4.2', '>=4.2.1'

gem 'database_cleaner'
gem 'factory_girl_rails'
gem 'faker'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.6'
  gem 'httparty', '~>0.17', '>=0.17.0'

  gem 'mongoid-rspec', '~> 4.0.0'
  gem 'capybara', '~> 2.10.1'
  gem 'poltergeist', '~> 1.11.0'
  gem 'selenium-webdriver', '~> 2.53.4'
  gem 'chromedriver-helper', '~>1.0.0'
  gem 'launchy', '~>2.4.3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap', '~>4.3'
  gem 'rails-assets-angular', '~>1.5', '>=1.5.8'
  gem 'rails-assets-angular-ui-router', '~>0.3', '>=0.3.1'
  gem 'rails-assets-angular-resource', '~>1.5', '>=1.5.8'
end

