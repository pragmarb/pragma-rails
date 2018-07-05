# frozen_string_literal: true

require 'pragma'
require 'rails'

require 'pragma/rails/version'
require 'pragma/rails/controller'
require 'pragma/rails/resource_controller'
require 'pragma/rails/errors'

require 'generators/pragma/resource_generator' if defined?(::Rails::Generators)

module Pragma
  # Ruby on Rails integration for the Pragma architecture.
  module Rails
  end
end
