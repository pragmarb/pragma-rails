FactoryGirl.define do
  factory :article do
    association :category
    sequence(:title) { |n| "Article #{n}" }
    body { 'This is my beautiful blog article.' }
  end
end
