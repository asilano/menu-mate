class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_properties, dependent: :destroy
  has_many :tags, through: :recipe_properties
  has_many :plan_days, dependent: :nullify
  has_one :leftovers_source, required: false, dependent: :destroy

  validates :name, presence: true

  accepts_nested_attributes_for :leftovers_source, allow_destroy: true
end
