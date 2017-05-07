# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'pragma/rails'

module Dummy
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Configures the URL options to use outside of the request context.
    config.action_mailer.default_url_options = {
      host: 'www.example.com'
    }
  end
end
