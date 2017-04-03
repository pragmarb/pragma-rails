module API
  module V1
    module Article
      module Contract
        class Base < Pragma::Contract::Base
          property :category
          property :title, type: coercible(:string)
          property :body, type: coercible(:string)

          validation do
            required(:category).filled(:str?)
            required(:title).filled(:str?)
            required(:body).filled(:str?)
          end

          def category=(val)
            super ::Category.find_by(val)
          end
        end
      end
    end
  end
end
