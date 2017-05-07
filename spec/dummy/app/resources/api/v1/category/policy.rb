module API
  module V1
    module Category
      class Policy < Pragma::Policy::Base
        class Scope < Pragma::Policy::Base::Scope
          def resolve
            scope.all
          end
        end

        def show?
          true
        end
      end
    end
  end
end
