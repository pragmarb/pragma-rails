require 'factory_bot_rails'

FactoryBot.factories.clear
FactoryBot.definition_file_paths += [Rails.root.join('spec', 'factories').to_s]
FactoryBot.reload

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
