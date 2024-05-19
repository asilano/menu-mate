class Tag < ApplicationRecord
  belongs_to :user
  has_many :taggings
  has_many :recipes, through: :taggings, source: :taggable, source_type: "Recipe"
  has_many :plan_days, through: :taggings, source: :taggable, source_type: "PlanDay"

  validates :name, presence: true
end
