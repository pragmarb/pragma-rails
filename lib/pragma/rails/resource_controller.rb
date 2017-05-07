# frozen_string_literal: true

module Pragma
  module Rails
    # Exposes CRUD operations on a resource through a Rails controller.
    #
    # @author Alessandro Desantis
    module ResourceController
      def self.included(klass)
        klass.include Controller
        klass.extend ClassMethods
        klass.include InstanceMethods
      end

      module ClassMethods # :nodoc:
        # Returns the name of the resource this controller refers to.
        #
        # @return [String]
        #
        # @example
        #   API::V1::PostsController.resource_name => 'Post'
        def resource_name
          name.demodulize.chomp('Controller').singularize
        end

        # Returns the expected class of the provided operation on this resource.
        #
        # Note that this does not mean the operation is actually supported. Use {#operation?} for
        # that.
        #
        # @param operation_name [Symbol] name of the operation
        #
        # @return [String]
        #
        # @see #operation?
        #
        # @example
        #   API::V1::PostsController.operation_klass(:create) => 'API::V1::Post::Operation::Create'
        def operation_klass(operation_name)
          [name.deconstantize].tap do |klass|
            klass << "#{resource_name}::Operation::#{operation_name.to_s.camelize}"
          end.join('::')
        end

        # Returns whether the provided operation is supported on this resource.
        #
        # @param operation_name [Symbol] name of the operation
        #
        # @return [Boolean]
        def operation?(operation_name)
          class_exists? operation_klass(operation_name)
        end

        private

        def class_exists?(klass)
          begin
            klass.constantize
          rescue NameError => e
            raise e unless e.message.end_with?("uninitialized constant #{klass}")
          end

          Object.const_defined?(klass)
        end
      end

      module InstanceMethods # :nodoc:
        # If an action that does not exist is called on this controller, tries to find and run
        # an operation on the current resource with the same name.
        #
        # For instance, +API::V1::PostsController#create+ would try to find and run
        # +API::V1::Post::Operation::Create+.
        #
        # @param action_name [String] name of the missing action
        def action_missing(action_name)
          send(action_name)
        end

        # Supports running missing actions.
        #
        # @see #action_missing
        def method_missing(method_name, *arguments, &block)
          return super unless self.class.operation?(method_name)
          run self.class.operation_klass(method_name)
        end

        # Supports running missing actions.
        #
        # @see #action_missing
        def respond_to_missing?(method_name, include_private = false)
          self.class.operation?(method_name) || super
        end
      end
    end
  end
end
