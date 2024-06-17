FactoryBot.define do
  factory :leftover do
    name { "beef" }
    association :user
  end
end
