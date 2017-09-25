module API
  module V1
    module Article
      module Decorator
        class Instance < Pragma::Decorator::Base
          feature Pragma::Decorator::Type
          feature Pragma::Decorator::Association
          feature Pragma::Decorator::Timestamp

          property :id
          property :title
          property :body
          belongs_to :category, decorator: API::V1::Category::Decorator::Instance
          timestamp :created_at
          timestamp :updated_at
        end
      end
    end
  end
end
