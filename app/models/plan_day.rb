class PlanDay < ApplicationRecord
  belongs_to :menu_plan
  belongs_to :recipe
  has_many :taggings, as: :taggable
  has_many :tags, through: :taggings
end
