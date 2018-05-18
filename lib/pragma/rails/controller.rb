# frozen_string_literal: true

module Pragma
  module Rails
    # This mixin should be included in a Rails controller to provide integration with Pragma
    # operations.
    #
    # @author Alessandro Desantis
    module Controller
      def self.included(klass)
        klass.include InstanceMethods
      end

      module InstanceMethods # :nodoc:
        # Runs an operation, then responds with the returned status code, headers and resource.
        #
        # @param operation_klass [Class|String] a subclass of +Pragma::Operation::Base+
        def run(operation_klass)
          operation_const = if operation_klass.is_a?(Class)
            operation_klass
          else
            operation_klass.to_s.constantize
          end

          result = operation_const.call(
            operation_params,
            'current_user' => operation_user
          )

          result['result.response'].headers.each_pair do |key, value|
            response.headers[key] = value
          end

          if result['result.response'].entity
            render(
              status: result['result.response'].status,
              json: entity_to_hash(result['result.response'].entity).as_json
            )
          else
            head result['result.response'].status
          end
        end

        protected

        # Returns the parameters to pass to Pragma operations.
        #
        # By default, this is the +params+ hash.
        #
        # @return [Hash]
        def operation_params
          params.to_unsafe_h.with_indifferent_access
        end

        # Returns the currently authenticated user (for policies).
        #
        # By default, calls +current_user+ if the controller responds to it.
        #
        # @return [Object]
        def operation_user
          current_user if respond_to?(:current_user)
        end

        private

        def entity_to_hash(entity)
          options = {
            user_options: {
              expand: params[:expand],
              current_user: operation_user
            }
          }

          if entity.is_a?(Array)
            entity.map { |e| entity_to_hash(e) }
          elsif entity.respond_to?(:to_hash)
            entity.method(:to_hash).arity.zero? ? entity.to_hash : entity.to_hash(options)
          else
            entity.as_json(options)
          end
        end
      end
    end
  end
end
