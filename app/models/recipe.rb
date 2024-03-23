class Recipe < ApplicationRecord
  belongs_to :user
  has_many :taggings
  has_many :tags, through: :taggings

  validates :name, presence: true
end
