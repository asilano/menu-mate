class MenuPlan < ApplicationRecord
  belongs_to :user
  has_many :plan_days, -> { order("day_number") }, dependent: :destroy
end
