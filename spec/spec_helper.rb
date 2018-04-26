require_relative '../lib/stego'

Stego.configure do |config|
  config.logger = Logger.new('/dev/null')
  config.kafka_urls = [ENV['KAFKA_URL'] || 'localhost:9092']
  config.kafka_options = {}
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
