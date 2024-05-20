class PlanDay < ApplicationRecord
  belongs_to :menu_plan
  belongs_to :recipe, optional: true
  has_one :user, through: :menu_plan
  has_many :plan_day_restrictions, dependent: :destroy
  has_many :tags, through: :plan_day_restrictions
end
