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
          begin
            result = operation_klass.to_s.constantize.call!(
              params: operation_params.to_unsafe_h,
              current_user: operation_user
            )
          rescue Interactor::Failure => e
            if e.context.pragma_operation_failure
              result = e.context
            else
              raise e
            end
          end

          result.headers.each_pair do |key, value|
            response.headers[key] = value
          end

          if result.resource
            render status: result.status, json: resource_to_json(result.resource).as_json
          else
            head result.status
          end
        end

        protected

        # Returns the parameters to pass to Pragma operations.
        #
        # By default, this is the +params+ hash.
        #
        # @return [Hash]
        def operation_params
          params
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

        def resource_to_json(resource)
          options = {
            user_options: {
              expand: params[:expand],
              current_user: operation_user
            }
          }

          if resource.is_a?(Array)
            resource.map do |instance|
              resource_to_json(instance)
            end
          else
            if resource.respond_to?(:to_hash)
              resource.method(:to_hash).arity.zero? ? resource.to_hash : resource.to_hash(options)
            else
              resource.as_json(options)
            end
          end
        end
      end
    end
  end
end
