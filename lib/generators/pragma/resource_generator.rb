# frozen_string_literal: true

module Pragma
  class ResourceGenerator < ::Rails::Generators::NamedBase # :nodoc:
    source_root File.expand_path('../templates', __FILE__)

    class_option :version, type: :numeric, default: 1, desc: 'The API version to use', aliases: '-v'

    def copy_initializer_file
      copy_resource_files
      copy_controller
      copy_spec
      generate_route
    end

    private

    def full_class_name
      [namespace, class_name].map(&:to_s).join('::')
    end

    def namespaced_path
      namespaced? ? super : ''
    end

    def copy_resource_files
      directory(
        'resource/resource',
        "app/resources/#{namespaced_path}/api/v#{options['version']}/#{file_name}"
      )
    end

    def copy_controller
      # rubocop:disable Metrics/LineLength
      template(
        'resource/controller.rb',
        "app/controllers/#{namespaced_path}/api/v#{options['version']}/#{file_name.pluralize}_controller.rb"
      )
      # rubocop:enable Metrics/LineLength
    end

    def copy_spec
      template(
        'resource/spec.rb',
        "spec/requests/#{namespaced_path}/api/v#{options['version']}/#{file_name.pluralize}_spec.rb"
      )
    end

    def route_path
      ['api', "v#{options['version']}"]
    end

    # Taken from https://github.com/rails/rails/blob/master/railties/lib/rails/generators/rails/resource_route/resource_route_generator.rb
    def generate_route
      route_path.each_with_index do |namespace, index|
        write("namespace :#{namespace} do", index + 1)
      end

      path_fragment = if file_name.include?('_')
        ", path: '#{file_name.pluralize.tr('_', '-')}'"
      end

      # rubocop:disable Metrics/LineLength
      write(
        "resources :#{file_name.pluralize}, only: %i(index show create update destroy)#{path_fragment}",
        route_length + 1
      )
      # rubocop:enable Metrics/LineLength

      route_path.each_index do |index|
        write('end', route_length - index)
      end

      # route prepends two spaces onto the front of the string that is passed, this corrects that.
      # Also it adds a \n to the end of each line, as route already adds that we need to correct
      # that too.
      route route_string[2..-2]
    end

    def route_string
      @route_string ||= ''
    end

    def write(str, indent)
      @route_string = route_string + "#{'  ' * indent}#{str}\n"
    end

    def route_length
      route_path.length
    end
  end
end
