require 'capybara'

RSpec.configure do |config|
  config.include Rack::Test::Methods, type: :request
end
