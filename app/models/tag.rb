class Tag < ApplicationRecord
  belongs_to :user
  has_many :recipe_properties
  has_many :plan_day_restrictions
  has_many :recipes, through: :recipe_properties
  has_many :plan_days, through: :plan_day_restrictions

  validates :name, presence: true
end
