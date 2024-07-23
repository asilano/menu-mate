class Leftover < ApplicationRecord
  belongs_to :user
  has_many :leftovers_sources, dependent: :destroy

  validates :name, presence: true
end
