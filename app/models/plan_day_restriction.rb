class PlanDayRestriction < ApplicationRecord
  belongs_to :tag
  belongs_to :plan_day
end
