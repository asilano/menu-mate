class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_properties, dependent: :destroy
  has_many :tags, through: :recipe_properties
  has_many :plan_days, dependent: :nullify

  validates :name, presence: true
end
