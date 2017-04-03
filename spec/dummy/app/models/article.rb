class Article < ApplicationRecord
  belongs_to :category, inverse_of: :articles
end
