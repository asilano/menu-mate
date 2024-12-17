FactoryBot.define do
  factory :recipe do
    name { "Trout a la Creme" }
    multi_day_count { 1 }
    association :user
  end
end
