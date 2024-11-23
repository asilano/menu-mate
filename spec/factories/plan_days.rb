FactoryBot.define do
  factory :plan_day do
    menu_plan { nil }
    day_number { 1 }
    recipe { nil }
    tags { [] }
  end
end
