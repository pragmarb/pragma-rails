FactoryGirl.define do
  factory :article do
    association :category
    sequence(:title) { |n| "Article #{n}" }
    body { Faker::Lorem.paragraphs(3).join("\n\n") }
  end
end
