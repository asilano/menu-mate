class Tag < ApplicationRecord
  belongs_to :user
  has_many :taggings
  has_many :recipes, through: :taggings
  has_many :plan_days, through: :taggings

  validates :name, presence: true
end
