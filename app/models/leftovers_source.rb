class LeftoversSource < ApplicationRecord
  belongs_to :recipe
  belongs_to :leftover

  validates :num_days, numericality: { only_integer: true, greater_than: 0 }
end
