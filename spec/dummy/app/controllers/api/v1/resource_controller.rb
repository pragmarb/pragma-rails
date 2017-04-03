module API
  module V1
    class ResourceController < ApplicationController
      include Pragma::Rails::ResourceController
    end
  end
end
