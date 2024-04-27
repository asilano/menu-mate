FactoryBot.define do
  factory :menu_plan do
    user_id { nil }
    transient do
      num_days { 7 }
    end
    plan_days do
      num_days.times.map { |n| build(:plan_day, day_number: n) }
    end
  end
end
