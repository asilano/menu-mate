FactoryBot.define do
  factory :recipe do
    name { "Trout a la Creme" }
    association :user
  end
end
