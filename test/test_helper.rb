ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/pride'
require 'vcr'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  VCR.configure do |config|
    config.cassette_library_dir = "fixtures/vcr_cassettes"
    config.hook_into :webmock
    config.filter_sensitive_data('<KEY>') { ENV["google_books_api_key"] }
  end
end
