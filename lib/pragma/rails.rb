# frozen_string_literal: true

require 'pragma'
require 'rails'

require 'pragma/rails/version'
require 'pragma/rails/controller'
require 'pragma/rails/resource_controller'

if defined?(::Rails::Generators)
  require 'generators/pragma/resource_generator'
end

module Pragma
  # Ruby on Rails integration for the Pragma architecture.
  #
  # @author Alessandro Desantis
  module Rails
  end
end
