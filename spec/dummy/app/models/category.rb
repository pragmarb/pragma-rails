class Category < ApplicationRecord
  has_many :articles, inverse_of: :category
end
