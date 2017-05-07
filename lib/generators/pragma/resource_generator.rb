module Pragma
  class ResourceGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path("../templates", __FILE__)

    class_option :version, type: :numeric, default: 1, desc: 'The API version to use', aliases: '-v'

    def copy_initializer_file
      directory 'resource', "app/resources/api/v#{options['version']}/#{file_name}"
    end
  end
end
