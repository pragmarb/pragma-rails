module API
  module V1
    module Category
      module Decorator
        class Collection < Pragma::Decorator::Base
          feature Pragma::Decorator::Type
          feature Pragma::Decorator::Collection
          feature Pragma::Decorator::Pagination

          decorate_with Instance
        end
      end
    end
  end
end
