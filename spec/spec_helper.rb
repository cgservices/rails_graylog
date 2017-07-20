require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatters = [
  SimpleCov::Formatter::RcovFormatter,
  SimpleCov::Formatter::HTMLFormatter
]

SimpleCov.start

require 'bundler/setup'
require 'rails_graylog'
require 'ostruct'
require 'faker'
require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.order = :random

  Kernel.srand config.seed

  config.expose_dsl_globally = true
end
