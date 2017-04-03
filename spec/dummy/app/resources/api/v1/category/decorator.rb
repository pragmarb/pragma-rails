module API
  module V1
    module Category
      class Decorator < Pragma::Decorator::Base
        feature Pragma::Decorator::Type

        property :id
        property :name
      end
    end
  end
end
