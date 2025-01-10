class Tag < ApplicationRecord
  include ColourUtils

  belongs_to :user
  has_many :recipe_properties
  has_many :plan_day_restrictions
  has_many :recipes, through: :recipe_properties
  has_many :plan_days, through: :plan_day_restrictions

  validates :name, presence: true
  validates :colour, format: /\A#(?:[A-F0-9]{3}){1,2}\z/i
end
