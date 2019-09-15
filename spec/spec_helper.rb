require 'mongoid-rspec'
require 'capybara/rspec'
require_relative 'support/database_cleaners.rb'
require_relative 'support/api_helper.rb'

browser = :chrome
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: browser)
end

require 'capybara/poltergeist' do |app|
  Capybara::Poltergeist::Driver.new(app, phantomjs_logger: StringIO.new)
end

RSpec.configure do |config|
  config.include ApiHelper, type: :request

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
