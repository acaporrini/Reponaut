require 'vcr'
require 'capybara/rspec'
require 'rack/test'
require 'simplecov'
require 'dotenv'
require 'capybara-screenshot/rspec'

Dotenv.load('.env.test')

ENV['RACK_ENV'] = 'test'

SimpleCov.start do
  add_filter '/spec/'
end

require_relative '../reponaut'

Capybara.app = Reponaut::Server
root = File.expand_path(File.join(File.dirname(__FILE__), '../tmp'))
Capybara::Screenshot.instance_variable_set :@capybara_root, root

def app
  Reponaut::Server
end

VCR.configure do |config|
  config.hook_into :webmock
  config.cassette_library_dir = 'spec/vcr'
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :new_episodes }
  config.filter_sensitive_data('<TOKEN>') do |interaction|
    auths = interaction.request.headers['Authorization'].first
    if (match = auths.match /^token\s+([^,\s]+)/)
      match.captures.first
    end
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.include Rack::Test::Methods
  config.include Capybara::DSL
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
