FactoryBot.define do
  factory :tag do
    name { "vegetarian" }
    association :user
  end
end
