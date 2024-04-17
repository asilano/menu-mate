class Recipe < ApplicationRecord
  belongs_to :user
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings
  has_many :plan_days

  validates :name, presence: true
end
