FactoryBot.define do
  factory :menu_plan do
    association :user
    transient do
      num_days { 7 }
    end
    plan_days do
      num_days.times.map { |n| build(:plan_day, day_number: n) }
    end
  end
end
