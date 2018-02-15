module API
  module V1
    module Article
      module Operation
        class Index < Pragma::Operation::Index
          self['ordering.default_column'] = :id
          self['ordering.default_direction'] = :asc
        end
      end
    end
  end
end
