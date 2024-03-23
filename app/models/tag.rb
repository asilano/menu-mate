class Tag < ApplicationRecord
  belongs_to :user
  has_many :taggings
  has_many :recipes, through: :taggings

  validates :name, presence: true
end
