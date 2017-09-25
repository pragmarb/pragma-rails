# frozen_string_literal: true

require 'pragma'
require 'rails'

require 'pragma/rails/version'
require 'pragma/rails/controller'
require 'pragma/rails/resource_controller'

require 'generators/pragma/resource_generator' if defined?(::Rails::Generators)

module Pragma
  # Ruby on Rails integration for the Pragma architecture.
  #
  # @author Alessandro Desantis
  module Rails
  end
end
