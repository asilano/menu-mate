class Recipe < ApplicationRecord
  belongs_to :user
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :plan_days, dependent: :nullify

  validates :name, presence: true
end
