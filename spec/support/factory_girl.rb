require 'factory_girl_rails'

FactoryGirl.factories.clear
FactoryGirl.definition_file_paths += [Rails.root.join('spec', 'factories').to_s]
FactoryGirl.reload

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
end
