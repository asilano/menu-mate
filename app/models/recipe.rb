class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_properties, dependent: :destroy
  has_many :tags, through: :recipe_properties
  has_many :plan_days, dependent: :nullify
  has_one :leftovers_source, required: false, dependent: :destroy
  has_one :leftovers_sink, required: false, dependent: :destroy

  validates :name, presence: true
  validates :multi_day_count, presence: true, numericality: { only_integer: true, greater_than: 0 }

  accepts_nested_attributes_for :leftovers_source, allow_destroy: true
  accepts_nested_attributes_for :leftovers_sink, allow_destroy: true
end
