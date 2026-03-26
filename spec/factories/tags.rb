FactoryBot.define do
  factory :tag do
    name { "vegetarian" }
    association :user
    restrictive { false }
  end
end
